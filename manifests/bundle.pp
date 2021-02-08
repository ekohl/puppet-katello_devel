# @summary Run a bundle command, possibly under SCL
# @api private
define katello_devel::bundle(
  Array[String] $environment = [],
  $unless = undef,
  Optional[String] $scl_ruby = $katello_devel::scl_ruby,
  Optional[String] $scl_nodejs = $katello_devel::scl_nodejs,
  Optional[String] $scl_postgresql = $katello_devel::scl_postgresql,
  $user = $katello_devel::user,
  $cwd = $katello_devel::foreman_dir,
  Integer[0] $timeout = 600,
) {
  if $scl_ruby or $scl_nodejs or $scl_postgresql {
    $command = "scl enable ${scl_ruby} ${scl_nodejs} ${scl_postgresql} 'bundle ${title}'"
  } else {
    $command = "bundle ${title}"
  }

  exec { "bundle-${title}":
    command     => $command,
    environment => $environment + ["HOME=/home/${user}"],
    cwd         => $cwd,
    user        => $user,
    logoutput   => 'on_failure',
    timeout     => $timeout,
    path        => ['/usr/bin', '/bin'],
    unless      => $unless,
  }
}
