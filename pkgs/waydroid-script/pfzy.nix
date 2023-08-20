{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
with python3Packages;
  buildPythonPackage rec {
    pname = "pfzy";
    version = "0.3.4";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "kazhala";
      repo = "pfzy";
      rev = "refs/tags/${version}";
      hash = "sha256-+Ba/yLUfT0SPPAJd+pKyjSvNrVpEwxW3xEKFx4JzpYk=";
    };

    nativeBuildInputs = [
      poetry-core
    ];

    pythonImportsCheck = [
      "pfzy"
    ];

    meta = with lib; {
      description = "Python port of the fzy fuzzy string matching algorithm";
      homepage = "https://github.com/kazhala/pfzy";
      license = licenses.mit;
      maintainers = with maintainers; [fab];
    };
  }
