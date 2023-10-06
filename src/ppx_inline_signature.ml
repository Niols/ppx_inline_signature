open Ppxlib

module StringMap = Map.Make(String)

let process_binding descriptions binding =
  match binding.pvb_pat.ppat_desc with
  | Ppat_var { txt=name; _ } ->
    (
      match StringMap.find_opt name descriptions with
      | None -> failwith "process_binding: no description"
      | Some description ->
        {
          binding with pvb_pat = {
            binding.pvb_pat
            with
              ppat_desc =
                Ppat_constraint (binding.pvb_pat, description.pval_type)
          }
        }
    )
  | _ -> failwith "process_binding: wrong shape"

let process descriptions rec_flag bindings =
  assert (descriptions <> []);
  let descriptions =
    List.to_seq descriptions
    |> Seq.map (fun description -> (description.pval_name.txt, description))
    |> StringMap.of_seq
  in
  let bindings = List.map (process_binding descriptions) bindings in
  Pstr_value (rec_flag, bindings)

let rec impl current_descriptions structure_items =
  match structure_items with
  | [] -> []
  | structure_item :: structure_items ->
    match structure_item.pstr_desc with
    | Pstr_primitive ({ pval_prim = []; _ } as description) ->
      impl (description :: current_descriptions) structure_items
    | Pstr_value (rec_flag, bindings) when current_descriptions <> [] ->
      { structure_item with pstr_desc = process (List.rev current_descriptions) rec_flag bindings }
      :: impl [] structure_items
    | _ when current_descriptions <> [] ->
      failwith "impl"
    | _ ->
      structure_item :: impl [] structure_items

let impl structure_items = impl [] structure_items

let () = Driver.register_transformation ~impl "ppx_inline_interface"
