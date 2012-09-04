Kaching!
========

Monitoring should be fun. When a new project goes live we want immediate
feedback.

Kaching aims to be a general-purpose dashboard/extreme-feedback-device that can
be used to display useful development metrics, such as build-status,
commit-log, coverage-metrics; along with various motivational production
metrics, such as "how much money we've made today", "how many sales we've made"

Design
------

This describes the planned design, not what is actually implemented! The
service is written using Node.js, Express & Socket.IO. Dashboards are internal
tools, so we control the browser platform. For this reason, we don't really
care about IE -- the cost for compatibility is too high.

The server will host multiple dashboard pages, each one consisting of a layout
filled with widgets. In order to make the system as generic as possible, all
widgets will be updated via posts to HTTP endpoints.  It is expected that
background services will be run that will provide updates to the page via the
Socket.IO connection. The data provided to the dashboard will be persisted
using a lightweight mechanism, probably Redis.

As far as pragmatic, the app will adhere to the 12 Factor app guidelines.

Planned Widgets
---------------
* Extreme feedback widget (big green/red box)
* Commit log (with Git/SVN adapter)
* Revenue
