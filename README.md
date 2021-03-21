<div class="title-block" style="text-align: center;" align="center">

# BSC Development Workstation (BDW)

A graphical interface for developing BSV/BH designs with BSC

---

</div>

The BSC Development Workstation (BDW) is full-featured graphical
environment in which you can create, edit, compile, simulate,
analyze, and debug BSV/BH designs with [BSC].

BDW can **connect to a waveform viewer**, such as GtkWave, to allow
source-level debugging of simulations:
* **View signal values as source-level types**
  (enums, structs, tagged unions) rather than single bit vectors
* **Add sets of signals to an attached waveform viewer**
  for a selected rule, method, or module instance in the hierarchy
  * View the CAN_FIRE and WILL_FIRE for rules
  * View the RDY, EN, argument, and result ports for a method

BDW can also **connect to an editor**, such as Emacs or Vim, to
pull up the source for any type, function, rule, module,
instantiation, etc, from the BDW's various viewer windows.

Among the viewer windows for navigating a design are:

* **Schedule Analysis**
  * View rule orders, rule relationships, scheduling warnings, and method uses
  * Jump to the source for any rule or method
  * Add the related signals for any rule or method to the attached waveform viewer
* **Module Browser**
  * View the hierarchy of modules, instances, and rules
  * Click on any module, instance, rule, or method to view more information
  * Jump to the source for any item
  * Add the related signals for any item to the attached waveform viewer
* **Package Browser**
  * View the types, functions, and modules defined in libraries and project source files
  * Jump to the source for any item
  * Open any type in the Type Browser 
* **Type Browser**
  * View more info about a given type or its component types

All of this information about packages, modules, types, and schedules
is provided by the `bluetcl` API. BDW is a Tcl/Tk application that provides
the graphical interface to this information.

BDW includes an **import-BVI wizard** that automates much of the process
of importing Verilog modules into BSC designs.

BDW can also export a project as a Makefile.

[bsc]: https://github.com/B-Lang-org/bsc

---

## Community

To receive announcements about BDW and related projects, subscribe to
[b-lang-announce@groups.io](https://groups.io/g/b-lang-announce).

For questions and discussion about BSC/Bluetcl source, subscribe to the
developers' mailing list [bsc-dev@groups.io](https://groups.io/g/bsc-dev).

For any questions or discussion about Bluespec HDLs, using BDW or BSC, or
related projects, subscribe to [b-lang-discuss@groups.io](https://groups.io/g/b-lang-discuss).

IRC users might try joining the `#bluespec` channel on [FreeNode](https://freenode.net).

There's also a [bluespec](https://stackoverflow.com/questions/tagged/bluespec)
tag on StackOverflow.

And we've enabled the [Discussions](https://github.com/B-Lang-org/bsc/discussions)
tab in this GitHub repo.
This is a new feature to support discussion within the project itself.
Feel free to give it a try and see if it can be useful to our community.

---

## Requirements

* [BSC] installation (with `bluetcl` in the user's `PATH`)
* Tk (and Tcl)
* Itk (and Itcl)

For waveform viewing:
* Perl (for `exec/fixvcd` script)
* Gtkwave (or Verdi nWave)

For correlating with source files:
* Emacs (with `emacsclient`) or GVim editor

For viewing scheduling graphs visually:
* Tcldot/Graphviz

---

## Install/Run

You can install with:

    $ make install

And then you can run with:

    $ ./inst/bin/bdw

---

## Documenation

The `doc` directory contains a User Guide written in LaTeX.
You can build and install the `user_guide.pdf` with:

    $ make install-doc

This requires LaTex tools, such as `pdflatex`.

---

## Testing

The directory `testing/bsc.bdw` contains tests for BDW that can be run
using the infrastructure of the [bsc-testsuite] repo.  Simply copy the
directory to a clone of that repo:

    $ cp -r testsing/bsc.bdw /path/to/bsc-testsuite/
    $ cd /path/to/bsc-testsuite/bsc.bdw/
    $ make check

[bsc-testsuite]: https://github.com/B-Lang-org/bsc-testsuite

---

## Notes

BDW builds and runs on macOS, using the native Tcl/Tk/Itcl/Itk, but
the appearance is odd and difficult to use.  Perhaps building with a
different Tk (perhaps with X11) might give a better appearance.

BDW uses a local copy of the IWidgets package.
It might be nice to remove that and instead require users to have
IWidgets installed in their environment (as we do with Itcl/Itk).
However, the local copy has modifications, so "unvendoring" would
lose some of the tweaks and extensions that have been applied to
give BDW its current appearance.
It would be worth identifying those changes and deciding whether
we can live without them or implement them without vendoring.
If there are only a few modified widgets, we could at least just
override those definitions without vendoring the entire package.
BDW already does this with some Tk widgets; the directory `src/tk/`
contains code that overrides Tk definitions, for example.
Note also that the file `scrolledcheckbox.tcl` in `src/workstation/`
is adapted from the IWidgets `checkbox.itk`.

---

## License

The BSC Development Workstation is available under the BSD license.
The source code also includes several other components under various
license agreements (all of it open/copyleft software).
See `COPYING` for copyright and license details.
