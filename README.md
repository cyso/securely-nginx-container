# Serverless ModSecurity with OWASP Core Rule Set

The combination of this docker container and the helm chart provide a way of deploying the following containers in a single pod:

* Nginx with Modsecurity, based on: https://github.com/coreruleset/modsecurity-crs-docker/tree/master
* Securely components:
  * [Securely blocker](https://git.securely.ai/securely/common/blocker)
  * Securely secrule configurato (disabled by default, proprietary)
* Filebeat

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

This chart is especially useful used as a subchart or dependency in other helm charts. Include the helm chart as a dependency by including this in the Chart.yaml of a parent's chart:

```
dependencies:
  - name: securely-proxy
    repository: "https://charts.k8s.cyso.io/"
    version: "~1"
```

# Values
Check the [values.yml](/cyso/securely-nginx-container/blob/main/charts/securely-proxy/values.yaml) file for all the available settings for this chart.

## Values by `nginx_modsec.config` 
Environment variables of the nginx modsecurity container are used by `nginx_modsec.config`. This makes all the variables in the upstream container configurable, including [Nginx](https://github.com/coreruleset/modsecurity-crs-docker/tree/master#nginx-env-variables) and [ModSecurity](https://github.com/coreruleset/modsecurity-crs-docker/tree/master#modsecurity-env-variables) variables.

For example:

```
nginx_modsec:
  config:
    PARANOIA: 1
    MODSEC_RULE_ENGINE: DetectionOnly
```
## Important values

### ModSecurity

| Key                          | Default | Description                                                                                             | Type |
| ---------------------------- | ------- | ------------------------------------------------------------------------------------------------------- | ---- |
| nginx_modsec.config.PARANOIA | 1       | Sets the [paranioa level](https://coreruleset.org/20211028/working-with-paranoia-levels/) for OWASP CRS | int  |

### Securely blocker
| Key                              | Default                      | Type |
| -------------------------------- | ---------------------------- | ---- |
| securely_blocker.config.GRPC_URL | Url for connecting Grpc      | str  |
| securely_blocker.config.USERNAME | Username for connecting Grpc | str  |
| securely_blocker.config.PASSWORD | Password for connecting Grpc | str  |


### Filebeat

| Key                               | Default                                     | type |
| --------------------------------- | ------------------------------------------- | ---- |
| filebeat.config.organization_name | Organisation name used in Securely/Logstash | str  |
| filebeat.config.logstash_hosts    | List of logstash hosts                      | list |

### Securely secrule configrator
When enabled

| Key                                          | Default                      | Type |
| -------------------------------------------- | ---------------------------- | ---- |
| securely_secruleconfigurator.config.GRPC_URL | Url for connecting Grpc      | str  |
| securely_secruleconfigurator.config.USERNAME | Username for connecting Grpc | str  |
| securely_secruleconfigurator.config.PASSWORD | Password for connecting Grpc | str  |
                                                                                                 
# Contributing
For information on how to contribute to this project, please see the [CONTRIBUTING](CONTRIBUTING.md) file.

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
