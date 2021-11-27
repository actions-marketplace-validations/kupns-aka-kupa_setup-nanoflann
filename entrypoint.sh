#!/bin/bash

function log()
{
  echo "::${1}::${*:2}"
}

function warning()
{
  log warning "${*}"
}

function debug()
{
  log debug "${*}"
}

version=${1:-latest}
owner=jlblancoc
repo=nanoflann
github="https://api.github.com"

releases=$(curl -s "${github}/repos/${owner}/${repo}/releases" | jq -cr '.[].tag_name')

latest=$(echo "${releases}" | head -n 1)

if [[ "${version}" == "latest" ]]
then
  version=${latest}
  debug "Found ${version} latest release"
else
  search=$(grep "${version}" <<< "${releases}" | head -n 1)

  if [[ -z "${search}" ]]
  then
    warning "Not found ${version} release"
    version=${latest}
  else
    version=${search}
    debug "Found ${search} release"
  fi
fi

debug "Installing ${version} release..."

release_source=$(curl -s "${github}/repos/${owner}/${repo}/releases/tags/${version}" | jq -rc '.tarball_url')

if ! command -v wget &> /dev/null
then
  curl -L "${release_source}" | tar -xvz > /dev/null
else
  wget -qO- "${release_source}" | tar -xvz > /dev/null
fi

project_install_dir="${GITHUB_WORKSPACE}/${repo}"
project_dir=$(find . -name "${owner}-${repo}*")

build_dir=${repo}_build_dir
cmake -E make_directory ${build_dir}
cmake -B ${build_dir} -S "${project_dir}" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX="${project_install_dir}" \
-DBUILD_EXAMPLES=OFF \
-DBUILD_BENCHMARKS=OFF \
-DBUILD_TESTS=OFF

cmake --install ${build_dir} --config Release

cmake_module_path="${project_install_dir}/lib/cmake/${repo}"
pkg_config_path="${project_install_dir}/lib/pkgconfig"

# shellcheck disable=SC2046
cp $(ls -d "${project_dir}"/cmake/*.cmake) "${cmake_module_path}"

{
  echo "nanoflann_DIR=${cmake_module_path}"
  echo "nanoflann_Dir=${cmake_module_path}"
  echo "PKG_CONFIG_PATH=${pkg_config_path}"
} >> "${GITHUB_ENV}"


debug "Successfully setup nanoflann of ${version} version"