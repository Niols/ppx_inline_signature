(lang dune 3.0)

(generate_opam_files true)

(version 0.2.0)

(license LGPL-3.0-or-later)
(authors "Niols <niols@niols.fr>")
(maintainers "Niols <niols@niols.fr>")
(source (github Niols/ppx_inline_signature))

(name ppx_inline_signature)

(package
 (name ppx_inline_signature)
 (synopsis "A syntax extension to inline value signatures in implementation files")
 (depends
  (ocaml (>= 4.08.0))
  (ppxlib (>= 0.9.0))))
