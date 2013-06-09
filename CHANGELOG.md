# JUN 2013 #

0.2  : 2013-06-08

    Third release.
    Added a new `fact`: bgp_neighbor.  Provides information
      on a specific BGP neighbor.
    Added a new method: get_neighbor.  Returns the new
      bgp_neighbor `fact`.
    Added a new method: clear_neighbor.  Clears specified
      neighbor in specified (optional) instance and optional
      'soft' bounce.
    Added two new example files showcasing the new methods:
      `bgp_neighbor.rb` and `bgp_clear.rb`.
    Significant updates to README.md

0.1b : 2013-06-08

    Second release.
    Rewrote the BGP library to return a custom data structure.
      This was necessary to make the library more extensible.
      In its previous incarnation, it returned a bunch of
      `puts` statements.  Not very helpful!
    Added LICENSE and CHANGELOG.md.
    Updated the example, `bgp_health.rb`, to utilize the
      BGP library correctly.
    Updated `README.md` to include new information and indicate
      the rewrite.

