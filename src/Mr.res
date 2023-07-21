module Table = {
  @module("../node_modules/material-react-table/dist/cjs/") @react.component
  external make: (~columns: array<'columnDef>, ~data: array<'dataDef>) => React.element =
    "MaterialReactTable"
}
