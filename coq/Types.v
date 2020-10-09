Require Import Coq.Strings.String.
Require Import Coq.ZArith.ZArith.
Require Import Info.

Open Scope type_scope.

Definition info (A : Type) := Info * A.

Definition P4Int := info (Z * option (Z * bool)).

Definition P4String := info string.

Inductive name :=
  | BareName : P4String -> name
  | QualifiedName : list P4String -> P4String -> name.

(* let to_bare : name -> name = function
  | BareName n
  | QualifiedName (_,n) -> BareName n

let name_info name : Info.t =
  match name with
  | BareName name -> fst name
  | QualifiedName (prefix, name) ->
     let infos = List.map fst prefix in
     List.fold_right Info.merge infos (fst name)

let name_eq n1 n2 =
  match n1, n2 with
  | BareName (_, s1),
    BareName (_, s2) ->
     s1 = s2
  | QualifiedName ([], (_, s1)),
    QualifiedName ([], (_, s2)) ->
     s1 = s2
  | _ -> false

and name_only n =
  match n with
  | BareName (_, s) -> s
  | QualifiedName (_, (_, s)) -> s
*)

Inductive KeyValue :=
  | MkKeyValue : Info -> P4String -> Expression -> KeyValue
with Annotation_body :=
  | AnnoEmpty : Annotation_body
  | AnnoUnparsed : list P4String -> Annotation_body
  | AnnoExpression : list Expression -> Annotation_body
  | AnnoKeyValue : list KeyValue -> Annotation_body
with Annotation :=
  | MkAnnotation : Info -> P4String -> Annotation_body -> Annotation
with Parameter' :=
  | MkParameter :
      Info ->
      list Annotation -> (* annotations *)
      option Direction -> (* direction *)
      Type' -> (* typ *)
      P4String -> (* variable *)
      option Expression -> (* opt_value *)
      Parameter'
with Op_uni :=
with Op_bin :=

(* and Op : sig
  type pre_uni =
      Not
    | BitNot
    | UMinus
  [@@deriving sexp,show,yojson]

  type uni = pre_uni info [@@deriving sexp,show,yojson]

  val eq_uni : uni -> uni -> bool

  type pre_bin =
      Plus
    | PlusSat
    | Minus
    | MinusSat
    | Mul
    | Div
    | Mod
    | Shl
    | Shr
    | Le
    | Ge
    | Lt
    | Gt
    | Eq
    | NotEq
    | BitAnd
    | BitXor
    | BitOr
    | PlusPlus
    | And
    | Or
  [@@deriving sexp,show,yojson]

  type bin = pre_bin info [@@deriving sexp,show,yojson]

  val eq_bin : bin -> bin -> bool
end *)
with Type' :=
  | Bool : Info -> Type'
  | Error : Info -> Type'
  | Integer : Info -> Type'
  | IntType : Info -> Expression -> Type'
  | BitType : Info -> Expression -> Type'
  | VarBit : Info -> Expression -> Type'
  (* this could be a typename or a type variable. *)
  | TypeName : Info -> name -> Type'
  (* SpecializedType base args *)
  | SpecializedType : Info -> Type' -> list Type' -> Type'
  (* HeaderStack header size *)
  | HeaderStack : Info -> Type' -> Expression -> Type'
  | Tuple : Info -> list Type' -> Type'
  | String : Info -> Type'
  | Void : Info -> Type'
  | DontCare : Info -> Type'
(* and MethodPrototype : sig
  type pre_t =
    Constructor of
      { annotations: Annotation.t list;
        name: P4String.t;
        params: Parameter.t list }
  | AbstractMethod of
      { annotations: Annotation.t list;
        return: Type.t;
        name: P4String.t;
        type_params: P4String.t list;
        params: Parameter.t list}
  | Method of
      { annotations: Annotation.t list;
        return: Type.t;
        name: P4String.t;
        type_params: P4String.t list;
        params: Parameter.t list}
        [@@deriving sexp,show,yojson]

  type t = pre_t info [@@deriving sexp,show,yojson]
end = struct
  type pre_t =
    Constructor of
      { annotations: Annotation.t list;
        name: P4String.t;
        params: Parameter.t list }
  | AbstractMethod of
      { annotations: Annotation.t list;
        return: Type.t;
        name: P4String.t;
        type_params: P4String.t list;
        params: Parameter.t list}
  | Method of
      { annotations: Annotation.t list;
        return: Type.t;
        name: P4String.t;
        type_params: P4String.t list;
        params: Parameter.t list}
    [@@deriving sexp,show,yojson]

  type t = pre_t info [@@deriving sexp,show,yojson]
end *)
with Argument :=
  | AExpression : Info -> Expression -> Argument
  | AKeyValue : Info -> P4String -> Expression -> Argument
  | AMissing : Info -> Argument
with Direction :=
  | In : Info -> Direction
  | Out : Info -> Direction
  | InOut : Info -> Direction
with Expression :=
  | ETrue : Info -> Expression
  | EFalse : Info -> Expression
  | EInt : Info -> P4Int -> Expression
  | EString : Info -> P4String -> Expression
  | EName : Info -> name -> Expression
  (* | ArrayAccess of
      { array: t;
        index: t } *)
  (* | BitStringAccess of
      { bits: t;
        lo: t;
        hi: t } *)
  (* | List of
      { values: t list } *)
  (* | Record of
      { entries: KeyValue.t list } *)
  | EUnaryOp : Info -> Op_uni -> Expression -> Expression
  | EBinaryOp : Info -> Op_bin -> Expression -> Expression -> Expression
  (* | Cast of
      { typ: Type.t;
        expr: t } *)
  (* | TypeMember of
      { typ: name;
        name: P4String.t } *)
  (* | ErrorMember of P4String.t *)
  (* | ExpressionMember of
      { expr: t;
        name: P4String.t } *)
  (* | Ternary of
      { cond: t;
        tru: t;
        fls: t } *)
  (* FunctionCall func type_args args *)
  | EFunctionCall : Info -> Expression -> list Type' -> list Argument -> Expression
  (* | NamelessInstantiation of
      { typ: Type.t [@key "type"];
        args: Argument.t list } *)
  (* | Mask of
      { expr: t;
        mask: t } *)
  (* | Range of
      { lo: t;
        hi: t } *).

(* and Table : sig
      type pre_action_ref =
        { annotations: Annotation.t list;
          name: name;
          args: Argument.t list }
      [@@deriving sexp,show,yojson]

      type action_ref = pre_action_ref info [@@deriving sexp,show,yojson]

      type pre_key =
        { annotations: Annotation.t list;
          key: Expression.t;
          match_kind: P4String.t }
      [@@deriving sexp,show,yojson]

      type key = pre_key info [@@deriving sexp,show,yojson]

      type pre_entry =
        { annotations: Annotation.t list;
          matches: Match.t list;
          action: action_ref }
      [@@deriving sexp,show,yojson { exn = true }]

      type entry = pre_entry info [@@deriving sexp,show,yojson]

      type pre_property =
          Key of
            { keys: key list }
        | Actions of
            { actions: action_ref list }
        | Entries of
            { entries: entry list }
        | Custom of
            { annotations: Annotation.t list;
              const: bool;
              name: P4String.t;
              value: Expression.t }
      [@@deriving sexp,show,yojson]

      type property = pre_property info [@@deriving sexp,show,yojson]

      val name_of_property : property -> string
    end = struct
              type pre_action_ref =
                { annotations: Annotation.t list;
                  name: name;
                  args: Argument.t list }
              [@@deriving sexp,show,yojson]

              type action_ref = pre_action_ref info [@@deriving sexp,show,yojson]

              type pre_key =
                { annotations: Annotation.t list;
                  key: Expression.t;
                  match_kind: P4String.t }
              [@@deriving sexp,show,yojson]

              type key = pre_key info [@@deriving sexp,show,yojson]

              type pre_entry =
                { annotations: Annotation.t list;
                  matches: Match.t list;
                  action: action_ref }
              [@@deriving sexp,show,yojson { exn = true }]

              type entry = pre_entry info [@@deriving sexp,show,yojson]

              type pre_property =
                  Key of
                    { keys: key list }
                | Actions of
                    { actions: action_ref list }
                | Entries of
                    { entries: entry list }
                | Custom of
                    { annotations: Annotation.t list;
                      const: bool;
                      name: P4String.t;
                      value: Expression.t }
              [@@deriving sexp,show,yojson]

              type property = pre_property info [@@deriving sexp,show,yojson]

              let name_of_property p =
                match snd p with
                | Key _ -> "key"
                | Actions _ -> "actions"
                | Entries _ -> "entries"
                | Custom {name; _} -> snd name
            end

and Match : sig
      type pre_t =
          Default
        | DontCare
        | Expression of
            { expr: Expression.t }
      [@@deriving sexp,show,yojson { exn = true }]

      type t = pre_t info [@@deriving sexp,show,yojson { exn = true }]
    end = struct
              type pre_t =
                  Default
                | DontCare
                | Expression of
                    { expr: Expression.t }
              [@@deriving sexp,show,yojson { exn = true }]

              type t = pre_t info [@@deriving sexp,show,yojson { exn = true }]
            end

and Parser : sig
      type pre_case =
        { matches: Match.t list;
          next: P4String.t }
      [@@deriving sexp,show,yojson { exn = true }]

      type case = pre_case info [@@deriving sexp,show,yojson]

      type pre_transition =
          Direct of
            { next: P4String.t }
        | Select of
            { exprs: Expression.t list;
              cases: case list }
      [@@deriving sexp,show,yojson]

      type transition = pre_transition info [@@deriving sexp,show,yojson]

      type pre_state =
        { annotations: Annotation.t list;
          name: P4String.t;
          statements: Statement.t list;
          transition: transition }
      [@@deriving sexp,show,yojson]

      type state = pre_state info [@@deriving sexp,show,yojson]
    end = struct
               type pre_case =
                 { matches: Match.t list;
                   next: P4String.t }
               [@@deriving sexp,show,yojson { exn = true }]

               type case = pre_case info [@@deriving sexp,show,yojson]

               type pre_transition =
                   Direct of
                     { next: P4String.t }
                 | Select of
                     { exprs: Expression.t list;
                       cases: case list }
               [@@deriving sexp,show,yojson]

               type transition = pre_transition info [@@deriving sexp,show,yojson]

               type pre_state =
                 { annotations: Annotation.t list;
                   name: P4String.t;
                   statements: Statement.t list;
                   transition: transition }
               [@@deriving sexp,show,yojson]

               type state = pre_state info [@@deriving sexp,show,yojson]
             end

and Declaration : sig
      type pre_t =
          Constant of
            { annotations: Annotation.t list;
              typ: Type.t [@key "type"];
              name: P4String.t;
              value: Expression.t }
        | Instantiation of
            { annotations: Annotation.t list;
              typ: Type.t [@key "type"];
              args: Argument.t list;
              name: P4String.t;
              init: Block.t option; }
        | Parser of
            { annotations: Annotation.t list;
              name: P4String.t;
              type_params: P4String.t list;
              params: Parameter.t list;
              constructor_params: Parameter.t list;
              locals: t list;
              states: Parser.state list }
        | Control of
            { annotations: Annotation.t list;
              name: P4String.t;
              type_params: P4String.t list;
              params: Parameter.t list;
              constructor_params: Parameter.t list;
              locals: t list;
              apply: Block.t }
        | Function of
            { return: Type.t;
              name: P4String.t;
              type_params: P4String.t list;
              params: Parameter.t list;
              body: Block.t }
        | ExternFunction of
            { annotations: Annotation.t list;
              return: Type.t;
              name: P4String.t;
              type_params: P4String.t list;
              params: Parameter.t list }
        | Variable of
            { annotations: Annotation.t list;
              typ: Type.t [@key "type"];
              name: P4String.t;
              init: Expression.t option }
        | ValueSet of
            { annotations: Annotation.t list;
              typ: Type.t [@key "type"];
              size: Expression.t;
              name: P4String.t }
        | Action of
            { annotations: Annotation.t list;
              name: P4String.t;
              params: Parameter.t list;
              body: Block.t }
        | Table of
            { annotations: Annotation.t list;
              name: P4String.t;
              properties: Table.property list }
        | Header of
            { annotations: Annotation.t list;
              name: P4String.t;
              fields: field list }
        | HeaderUnion of
            { annotations: Annotation.t list;
              name: P4String.t;
              fields: field list }
        | Struct of
            { annotations: Annotation.t list;
              name: P4String.t;
              fields: field list }
        | Error of
            { members: P4String.t list }
        | MatchKind of
            { members: P4String.t list }
        | Enum of
            { annotations: Annotation.t list;
              name: P4String.t;
              members: P4String.t list }
        | SerializableEnum of
            { annotations: Annotation.t list;
              typ: Type.t [@key "type"];
              name: P4String.t;
              members: (P4String.t * Expression.t) list }
        | ExternObject of
            { annotations: Annotation.t list;
              name: P4String.t;
              type_params: P4String.t list;
              methods: MethodPrototype.t list }
        | TypeDef of
            { annotations: Annotation.t list;
              name: P4String.t;
              typ_or_decl: (Type.t, t) alternative }
        | NewType of
            { annotations: Annotation.t list;
              name: P4String.t;
              typ_or_decl: (Type.t, t) alternative }
        | ControlType of
            { annotations: Annotation.t list;
              name: P4String.t;
              type_params: P4String.t list;
              params: Parameter.t list }
        | ParserType of
            { annotations: Annotation.t list;
              name: P4String.t;
              type_params: P4String.t list;
              params: Parameter.t list }
        | PackageType of
            { annotations: Annotation.t list;
              name: P4String.t;
              type_params: P4String.t list;
              params: Parameter.t list }
      [@@deriving sexp,show,yojson]

and t = pre_t info [@@deriving sexp,show,yojson]

and pre_field =
    { annotations: Annotation.t list;
      typ: Type.t [@key "type"];
      name: P4String.t } [@@deriving sexp,show,yojson]

and field = pre_field info [@@deriving sexp,show,yojson]

val name : t -> P4String.t

val name_opt : t -> P4String.t option

end = struct
  type pre_t =
      Constant of
        { annotations: Annotation.t list;
          typ: Type.t [@key "type"];
          name: P4String.t;
          value: Expression.t }
    | Instantiation of
        { annotations: Annotation.t list;
          typ: Type.t [@key "type"];
          args: Argument.t list;
          name: P4String.t;
          init: Block.t option; }
    | Parser of
        { annotations: Annotation.t list;
          name: P4String.t;
          type_params: P4String.t list;
          params: Parameter.t list;
          constructor_params: Parameter.t list;
          locals: t list;
          states: Parser.state list }
    | Control of
        { annotations: Annotation.t list;
          name: P4String.t;
          type_params: P4String.t list;
          params: Parameter.t list;
          constructor_params: Parameter.t list;
          locals: t list;
          apply: Block.t }
          [@name "control"]
    | Function of
        { return: Type.t;
          name: P4String.t;
          type_params: P4String.t list;
          params: Parameter.t list;
          body: Block.t }
    | ExternFunction of
        { annotations: Annotation.t list;
          return: Type.t;
          name: P4String.t;
          type_params: P4String.t list;
          params: Parameter.t list }
    | Variable of
        { annotations: Annotation.t list;
          typ: Type.t [@key "type"];
          name: P4String.t;
          init: Expression.t option }
    | ValueSet of
        { annotations: Annotation.t list;
          typ: Type.t [@key "type"];
          size: Expression.t;
          name: P4String.t }
    | Action of
        { annotations: Annotation.t list;
          name: P4String.t;
          params: Parameter.t list;
          body: Block.t }
    | Table of
        { annotations: Annotation.t list;
          name: P4String.t;
          properties: Table.property list }
    | Header of
        { annotations: Annotation.t list;
          name: P4String.t;
          fields: field list }
    | HeaderUnion of
        { annotations: Annotation.t list;
          name: P4String.t;
          fields: field list }
    | Struct of
        { annotations: Annotation.t list;
          name: P4String.t;
          fields: field list }
    | Error of
        { members: P4String.t list }
    | MatchKind of
        { members: P4String.t list }
    | Enum of
        { annotations: Annotation.t list;
          name: P4String.t;
          members: P4String.t list }
    | SerializableEnum of
        { annotations: Annotation.t list;
          typ: Type.t [@key "type"];
          name: P4String.t;
          members: (P4String.t * Expression.t) list }
    | ExternObject of
        { annotations: Annotation.t list;
          name: P4String.t;
          type_params: P4String.t list;
          methods: MethodPrototype.t list }
    | TypeDef of
        { annotations: Annotation.t list;
          name: P4String.t;
          typ_or_decl: (Type.t, t) alternative }
    | NewType of
        { annotations: Annotation.t list;
          name: P4String.t;
          typ_or_decl: (Type.t, t) alternative }
    | ControlType of
        { annotations: Annotation.t list;
          name: P4String.t;
          type_params: P4String.t list;
          params: Parameter.t list }
    | ParserType of
        { annotations: Annotation.t list;
          name: P4String.t;
          type_params: P4String.t list;
          params: Parameter.t list }
    | PackageType of
        { annotations: Annotation.t list;
          name: P4String.t;
          type_params: P4String.t list;
          params: Parameter.t list }
  [@@deriving sexp,show,yojson]

and t = pre_t info [@@deriving sexp,show,yojson]

and pre_field =
    { annotations: Annotation.t list;
      typ: Type.t [@key "type"];
      name: P4String.t } [@@deriving sexp,show,yojson]

and field = pre_field info [@@deriving sexp,show,yojson]

let name_opt d =
  match snd d with
  | Constant {name; _}
  | Instantiation {name; _}
  | Parser {name; _}
  | Control {name; _}
  | Function {name; _}
  | ExternFunction {name; _}
  | Variable {name; _}
  | ValueSet {name; _}
  | Action {name; _}
  | Table {name; _}
  | Header {name; _}
  | HeaderUnion {name; _}
  | Struct {name; _}
  | Enum {name; _}
  | SerializableEnum {name; _}
  | ExternObject {name; _}
  | TypeDef {name; _}
  | NewType {name; _}
  | ControlType {name; _}
  | ParserType {name; _}
  | PackageType {name; _} ->
      Some name
  | Error _
  | MatchKind _ ->
      None

let name d =
  match name_opt d with
  | Some name -> name
  | None -> failwith "this declaration does not have a name"
end

and Statement : sig
      type pre_switch_label =
          Default
        | Name of P4String.t
      [@@deriving sexp,show,yojson]

      type switch_label = pre_switch_label info [@@deriving sexp,show,yojson]

      type pre_switch_case =
          Action of
            { label: switch_label;
              code: Block.t }
        | FallThrough of
            { label: switch_label }
      [@@deriving sexp,show,yojson]

      type switch_case = pre_switch_case info [@@deriving sexp,show,yojson]

      type pre_t =
          MethodCall of
            { func: Expression.t;
              type_args: Type.t list;
              args: Argument.t list }
        | Assignment of
            { lhs: Expression.t;
              rhs: Expression.t }
        | DirectApplication of
            { typ: Type.t [@key "type"];
              args: Argument.t list }
        | Conditional of
            { cond: Expression.t;
              tru: t;
              fls: t option }
        | BlockStatement of
            { block: Block.t }
        | Exit
        | EmptyStatement
        | Return of
            { expr: Expression.t option }
        | Switch of
            { expr: Expression.t;
              cases: switch_case list }
        | DeclarationStatement of
            { decl: Declaration.t }
      [@@deriving sexp,show,yojson]

and t = pre_t info [@@deriving sexp,show,yojson]
end = struct
  type pre_switch_label =
      Default [@name "default"]
    | Name of P4String.t [@name "name"]
  [@@deriving sexp,show,yojson]

  type switch_label = pre_switch_label info [@@deriving sexp,show,yojson]

  type pre_switch_case =
      Action of
        { label: switch_label;
          code: Block.t }
    | FallThrough of
        { label: switch_label }
  [@@deriving sexp,show,yojson]

  type switch_case = pre_switch_case info [@@deriving sexp,show,yojson]

  type pre_t =
      MethodCall of
        { func: Expression.t;
          type_args: Type.t list;
          args: Argument.t list } [@name "method_call"]
    | Assignment of
        { lhs: Expression.t;
          rhs: Expression.t } [@name "assignment"]
    | DirectApplication of
        { typ: Type.t [@key "type"];
          args: Argument.t list } [@name "direct_application"]
    | Conditional of
        { cond: Expression.t;
          tru: t;
          fls: t option } [@name "conditional"]
    | BlockStatement of
        { block: Block.t } [@name "block"]
    | Exit [@name "exit"]
    | EmptyStatement [@name "empty_statement"]
    | Return of
        { expr: Expression.t option } [@name "return"]
    | Switch of
        { expr: Expression.t;
          cases: switch_case list } [@name "switch"]
    | DeclarationStatement of
        { decl: Declaration.t } [@name "declaration"]
  [@@deriving sexp,show,yojson]

and t = pre_t info [@@deriving sexp,show,yojson]
end

and Block : sig
      type pre_t =
        { annotations: Annotation.t list;
          statements: Statement.t list }
      [@@deriving sexp,show,yojson]

      type t = pre_t info [@@deriving sexp,show,yojson]
    end = struct
              type pre_t =
                { annotations: Annotation.t list;
                  statements: Statement.t list }
              [@@deriving sexp,show,yojson]

              type t = pre_t info [@@deriving sexp,show,yojson]
            end

type program =
    Program of Declaration.t list [@name "program"]
[@@deriving sexp,show,yojson] *)