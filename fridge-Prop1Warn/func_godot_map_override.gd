extends "res://addons/func_godot/src/map/func_godot_map.gd"

var property1detected := false
var firstpass = true

func build_entity_nodes() -> Array:
    property1detected = false
    var entity_nodes: Array = []
    entity_nodes.resize(entity_dicts.size())


    var omitted_entities: Array[int] = []
    var omitted_groups: Array[String] = []

    if map_settings.use_trenchbroom_groups_hierarchy:

        for entity_idx in range(0, entity_dicts.size()):
            var entity_dict: Dictionary = entity_dicts[entity_idx] as Dictionary
            var properties: Dictionary = entity_dict["properties"] as Dictionary

            if "_tb_type" in properties and properties["_tb_type"] == "_tb_layer":
                if "_tb_layer_omit_from_export" in properties and properties["_tb_layer_omit_from_export"] == "1":
                    omitted_entities.append(entity_idx)
                    omitted_groups.append("layer_" + str(properties.get("_tb_id", "-1")))


        for entity_idx in range(0, entity_dicts.size()):
            if omitted_entities.find(entity_idx) != -1:
                continue

            var entity_dict: Dictionary = entity_dicts[entity_idx] as Dictionary
            var properties: Dictionary = entity_dict["properties"] as Dictionary

            if "_tb_layer" in properties:
                if omitted_groups.find("layer_" + str(properties["_tb_layer"])) != -1:
                    omitted_entities.append(entity_idx)
                    if "_tb_id" in properties and properties["_tb_type"] == "_tb_group":
                        omitted_groups.append("group_" + str(properties.get("_tb_id", "-1")))

    for entity_idx in range(0, entity_dicts.size()):
        var entity_dict: Dictionary = entity_dicts[entity_idx] as Dictionary
        var properties: Dictionary = entity_dict["properties"] as Dictionary

        if map_settings.use_trenchbroom_groups_hierarchy:
            if omitted_entities.find(entity_idx) != -1:
                entity_nodes[entity_idx] = null
                continue
            if "_tb_group" in properties and omitted_groups.find("group_" + str(properties["_tb_group"])) != -1:
                entity_nodes[entity_idx] = null
                continue

        var node: Node = null
        var node_name: String = "entity_%s" % entity_idx

        var should_add_child: bool = should_add_children

        if "classname" in properties:
            var classname: String = properties["classname"]
            node_name += "_" + classname
            if classname in entity_definitions:
                var entity_definition: FuncGodotFGDEntityClass = entity_definitions[classname] as FuncGodotFGDEntityClass

                var name_prop: String
                if entity_definition.name_property in properties:
                    name_prop = str(properties[entity_definition.name_property])
                elif map_settings.entity_name_property in properties:
                    name_prop = str(properties[map_settings.entity_name_property])
                if not name_prop.is_empty():
                    node_name = "entity_" + name_prop

                if entity_definition is FuncGodotFGDSolidClass:
                    if entity_definition.spawn_type == FuncGodotFGDSolidClass.SpawnType.MERGE_WORLDSPAWN:
                        entity_nodes[entity_idx] = null
                        continue
                    if entity_definition.node_class != "":
                        node = ClassDB.instantiate(entity_definition.node_class)
                elif entity_definition is FuncGodotFGDPointClass:
                    if entity_definition.scene_file:
                        var flag: PackedScene.GenEditState = PackedScene.GEN_EDIT_STATE_DISABLED
                        if Engine.is_editor_hint():
                            flag = PackedScene.GEN_EDIT_STATE_INSTANCE
                        node = entity_definition.scene_file.instantiate(flag)
                    elif entity_definition.node_class != "":
                        node = ClassDB.instantiate(entity_definition.node_class)
                    if "rotation_degrees" in node and entity_definition.apply_rotation_on_map_build:
                        var angles: = Vector3.ZERO
                        if "angles" in properties or "mangle" in properties:
                            var key: = "angles" if "angles" in properties else "mangle"
                            var angles_raw = properties[key]
                            if not angles_raw is Vector3:
                                angles_raw = angles_raw.split_floats(" ")
                            if angles_raw.size() > 2:
                                angles = Vector3( - angles_raw[0], angles_raw[1], - angles_raw[2])
                                if key == "mangle":
                                    if entity_definition.classname.begins_with("light"):
                                        angles = Vector3(angles_raw[1], angles_raw[0], - angles_raw[2])
                                    elif entity_definition.classname == "info_intermission":
                                        angles = Vector3(angles_raw[0], angles_raw[1], - angles_raw[2])
                            else:
                                push_error("Invalid vector format for '" + key + "' in entity '" + classname + "'")
                        elif "angle" in properties:
                            var angle = properties["angle"]
                            if not angle is float:
                                angle = float(angle)
                            angles.y += angle
                        angles.y += 180
                        node.rotation_degrees = angles

                    if "scale" in node and entity_definition.apply_scale_on_map_build:
                        if "scale" in properties:
                            var scale_prop: Variant = properties["scale"]
                            if typeof(scale_prop) == TYPE_STRING:
                                var scale_arr: PackedStringArray = (scale_prop as String).split(" ")
                                match scale_arr.size():
                                    1: scale_prop = scale_arr[0].to_float()
                                    3: scale_prop = Vector3(scale_arr[1].to_float(), scale_arr[2].to_float(), scale_arr[0].to_float())
                                    2: scale_prop = Vector2(scale_arr[0].to_float(), scale_arr[0].to_float())
                            if typeof(scale_prop) == TYPE_FLOAT or typeof(scale_prop) == TYPE_INT:
                                node.scale *= scale_prop as float
                            elif node.scale is Vector3:
                                if typeof(scale_prop) == TYPE_VECTOR3 or typeof(scale_prop) == TYPE_VECTOR3I:
                                    node.scale *= scale_prop as Vector3
                            elif node.scale is Vector2:
                                if typeof(scale_prop) == TYPE_VECTOR2 or typeof(scale_prop) == TYPE_VECTOR2I:
                                    node.scale *= scale_prop as Vector2
                else:
                    node = Node3D.new()
                if entity_definition.script_class:
                    node.set_script(entity_definition.script_class)
        if not node:
            node = Node3D.new()

        node.name = node_name

        if properties[""] and not firstpass:
            var alert_str :String = "PROPERTY 1 IN THE HOUSE inside " + properties["classname"]
            
            Signals.toast.emit(ToastController.Toast.player_closed(alert_str))
            property1detected = true

        if "origin" in properties and entity_dict.brush_count < 1:
            var origin_vec: Vector3 = Vector3.ZERO
            var origin_comps: PackedFloat64Array = properties["origin"].split_floats(" ")
            if origin_comps.size() > 2:
                origin_vec = Vector3(origin_comps[1], origin_comps[2], origin_comps[0])
            else:
                push_error("Invalid vector format for 'origin' in " + node.name)
            if "position" in node:
                if node.position is Vector3:
                    node.position = origin_vec * map_settings.scale_factor
                elif node.position is Vector2:
                    node.position = Vector2(origin_vec.z, - origin_vec.y)
        else:
            if entity_idx != 0 and "position" in node:
                if node.position is Vector3:
                    node.position = entity_dict["center"] * map_settings.scale_factor

        entity_nodes[entity_idx] = node

        if should_add_child:
            queue_add_child(self, node)

    return entity_nodes

func _build_complete():
    reset_build_context()
    stop_profile("build_map")

    if not property1detected or firstpass:
        firstpass = false
        print("Build complete\n")
        emit_signal("build_complete")