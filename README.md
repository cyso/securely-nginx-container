# Serverless ModSecurity with OWASP Core Rule Set

The combination of this docker container and it's helm chart provide a  

## TL;DR
```
$ helm repo add cyso-securely-nginx-container https://charts.k8s.cyso.io/
$ helm install my-<chart-name> cyso-securely-nginx-container/
```


# Prerequisites

* This chart has only been tested on Kubernetes 1.20+
* Recent versions of Helm 3 are supported

# Installation

## Stand alone

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add cyso-securely-nginx-container https://charts.k8s.cyso.io/

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
cyso-securely-nginx-container` to see the charts.

To install the securely-proxy chart:

    helm install my-<chart-name> cyso-securely-nginx-container/securely-proxy

To uninstall the chart:

    helm delete my-<chart-name>

## As subchart/dependency

This chart is escpecially usefull used as asubchart or dependency in other helm charts. Include the helm chart as a dependency by including this in the Chart.yaml of a parents chart:

```
apiVersion: v2
name: ....
description: ....

type: application
version: 1.0.0
appVersion: "1.0.0"

dependencies:
  - name: securely-proxy
    repository: "https://charts.k8s.cyso.io/"
    version: "~1"
```

## Values
Check the [values.yml](/cyso/securely-nginx-container/blob/main/charts/securely-proxy/values.yaml) file for the available settings for this chart.

## Uninstalling the Chart

To delete the chart:

```shell
$ helm delete my-release
```

# License

> The following notice applies to all files contained within this Helm Chart and
> the Git repository which contains it:
>
> Copyright 2023 Cyso
>
> Licensed under the Apache License, Version 2.0 (the "License");
> you may not use this file except in compliance with the License.
> You may obtain a copy of the License at
>
>     http://www.apache.org/licenses/LICENSE-2.0
>
> Unless required by applicable law or agreed to in writing, software
> distributed under the License is distributed on an "AS IS" BASIS,
> WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> See the License for the specific language governing permissions and
> limitations under the License.
