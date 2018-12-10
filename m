From: Waiman Long <longman@redhat.com>
Subject: [PATCH v5 5/5] cgroup: Document bypass mode
Date: Mon, 10 Dec 2018 16:40:58 -0500
Message-ID: <1544478058-24252-6-git-send-email-longman@redhat.com>
References: <1544478058-24252-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544478058-24252-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Shakeel Butt <shakeelb@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Waiman Long <longman@redhat.com>
List-Id: linux-api@vger.kernel.org

The cgroup-v2.rst file is updated to document the new bypass mode.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 66 ++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 18 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 07e0613..17e6584 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -372,9 +372,16 @@ disabled by writing to the "cgroup.subtree_control" file::
 
   # echo "+cpu +memory -io" > cgroup.subtree_control
 
-Only controllers which are listed in "cgroup.controllers" can be
-enabled.  When multiple operations are specified as above, either they
-all succeed or fail.  If multiple operations on the same controller
+The prefixes '+', '-' and '#' are used to enable, disable or put
+a controller in the bypass mode respectively.  In the bypass mode,
+a controller is disabled in a cgroup, but it can be enabled again in
+its child cgroups as it will still be listed in "cgroup.controllers".
+Bypass mode can only be used on bypassable controllers.  Currently,
+only the cpu controller is bypassable.
+
+Only controllers which are listed in "cgroup.controllers" can be enabled
+or bypassed.  When multiple operations are specified as above, either
+they all succeed or fail.  If multiple operations on the same controller
 are specified, the last one is effective.
 
 Enabling a controller in a cgroup indicates that the distribution of
@@ -399,6 +406,20 @@ prefixed controller interface files from C and D.  This means that the
 controller interface files - anything which doesn't start with
 "cgroup." are owned by the parent rather than the cgroup itself.
 
+Once a bypassable controller is put into bypass mode in
+"cgroup.subtree_control", that controller can optionally be enabled
+again in child cgroups by writing the controller name with the '+ prefix
+into "cgroup.controllers".  Writing the controller name with the '#'
+prefix into "cgroup.controllers" resets the state back to bypass mode.
+The state of a bypassable controller cannot be changed anymore if it
+is enabled or bypassed in its "cgroup.subtree_control".
+
+The use of bypass mode thus allows a cgroup parent to have the ability
+to selectively enable a bypassable controller in a subset of its child
+cgroups instead of in either all or none of them. In other words, a
+bypassable can be enabled only on the cgroups that actually need it,
+if desired.
+
 
 Top-down Constraint
 ~~~~~~~~~~~~~~~~~~~
@@ -406,10 +427,11 @@ Top-down Constraint
 Resources are distributed top-down and a cgroup can further distribute
 a resource only if the resource has been distributed to it from the
 parent.  This means that all non-root "cgroup.subtree_control" files
-can only contain controllers which are enabled in the parent's
-"cgroup.subtree_control" file.  A controller can be enabled only if
-the parent has the controller enabled and a controller can't be
-disabled if one or more children have it enabled.
+can only contain controllers which are enabled or bypassed in the
+parent's "cgroup.subtree_control" file.  A controller can be enabled
+or bypassed only if the parent has the controller enabled or bypassed
+and the state of a controller can't be changed if one or more children
+have it enabled or bypassed.
 
 
 No Internal Process Constraint
@@ -834,11 +856,18 @@ All cgroup core files are prefixed with "cgroup."
 	should be granted along with the containing directory.
 
   cgroup.controllers
-	A read-only space separated values file which exists on all
+	A read-write space separated values file which exists on all
 	cgroups.
 
 	It shows space separated list of all controllers available to
-	the cgroup.  The controllers are not ordered.
+	the cgroup.  Controller names with '#' prefix are in bypass mode.
+	The controllers are not ordered.
+
+	When a controller is set into bypass mode in its parent's
+	"cgroup.subtree_control", its name prefixed with '+' or '#'
+	can be written to enable it or reset it back to bypass mode
+	respectively.  Controllers not in bypass mode are not allowed
+	to be written.
 
   cgroup.subtree_control
 	A read-write space separated values file which exists on all
@@ -848,12 +877,12 @@ All cgroup core files are prefixed with "cgroup."
 	which are enabled to control resource distribution from the
 	cgroup to its children.
 
-	Space separated list of controllers prefixed with '+' or '-'
-	can be written to enable or disable controllers.  A controller
-	name prefixed with '+' enables the controller and '-'
-	disables.  If a controller appears more than once on the list,
-	the last one is effective.  When multiple enable and disable
-	operations are specified, either all succeed or all fail.
+	Space separated list of controllers prefixed with '+', '-' or
+	'#' can be written to enable, disable or bypass controllers
+	respectively.  If a controller appears more than once on
+	the list, the last one is effective.  When multiple enable,
+	disable or bypass operations are specified, either all succeed
+	or all fail.
 
   cgroup.events
 	A read-only flat-keyed file which exists on non-root cgroups.
@@ -904,17 +933,18 @@ Controllers
 CPU
 ---
 
-The "cpu" controllers regulates distribution of CPU cycles.  This
+The "cpu" controller regulates distribution of CPU cycles.  This
 controller implements weight and absolute bandwidth limit models for
 normal scheduling policy and absolute bandwidth allocation model for
-realtime scheduling policy.
+realtime scheduling policy.  The cpu controller is bypassable.
 
 WARNING: cgroup2 doesn't yet support control of realtime processes and
 the cpu controller can only be enabled when all RT processes are in
 the root cgroup.  Be aware that system management software may already
 have placed RT processes into nonroot cgroups during the system boot
 process, and these processes may need to be moved to the root cgroup
-before the cpu controller can be enabled.
+before the cpu controller can be enabled unless bypass mode is used
+in those non-root cgroups.
 
 
 CPU Interface Files
-- 
1.8.3.1
