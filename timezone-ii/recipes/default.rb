#
# Cookbook Name:: timezone-ii
# Recipe:: default
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

log 'timezone setting' do
  message "Time zone setting: #{node.tz}"
  level :debug
end

# Make sure the tzdata database is installed. (Arthur David Olson, the computer
# timekeeping field is forever in your debt.)
package value_for_platform_family(
  'gentoo'  => 'timezone-data',
  'default' => 'tzdata'
)

if node.platform_family == 'debian'
  include_recipe "timezone-ii::#{node.platform_family}"

elsif node.os == "linux"
  # Load the generic Linux recipe if there's no better known way to change the
  # timezone.  Log a warning (unless this is known to be the best way on a
  # particular platform).
  log "fallback Linux" do
    message "Linux platform '#{node.platform}' is unknown to this recipe; " +
            "using fallback Linux method"
    level :warn
    not_if { %w( gentoo rhel ).include? node.platform_family }
  end

  include_recipe 'timezone-ii::linux-generic'

else
  log "unknown platform" do
    message "Don't know how to configure timezone for " +
            "'#{node.platform_family}'!"
    level :error
  end
end  # if/elsif/else platform-check

# vim:ts=2:sw=2: