From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 8/8] smack: documentation for the Smack namespace
Date: Thu, 21 May 2015 13:53:42 +0200
Message-ID: <1432209222-8479-9-git-send-email-l.pawelczyk@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1432209222-8479-1-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ionut Alexa <ionut.m.alexa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab@os>
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Adds Documentation/smack-namespace.txt.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 Documentation/security/00-INDEX            |   2 +
 Documentation/security/Smack-namespace.txt | 231 +++++++++++++++++++++++++++++
 MAINTAINERS                                |   1 +
 security/smack/Kconfig                     |   2 +
 4 files changed, 236 insertions(+)
 create mode 100644 Documentation/security/Smack-namespace.txt

diff --git a/Documentation/security/00-INDEX b/Documentation/security/00-INDEX
index 45c82fd..c03a220 100644
--- a/Documentation/security/00-INDEX
+++ b/Documentation/security/00-INDEX
@@ -6,6 +6,8 @@ SELinux.txt
 	- how to get started with the SELinux security enhancement.
 Smack.txt
 	- documentation on the Smack Linux Security Module.
+Smack-namespace.txt
+	- documentation on the Smack namespace implementation.
 Yama.txt
 	- documentation on the Yama Linux Security Module.
 apparmor.txt
diff --git a/Documentation/security/Smack-namespace.txt b/Documentation/security/Smack-namespace.txt
new file mode 100644
index 0000000..85197ff
--- /dev/null
+++ b/Documentation/security/Smack-namespace.txt
@@ -0,0 +1,231 @@
+
+                                      "Quis custodiet ipsos custodes?"
+                                                 - Satires of Juvenal
+
+
+--- What is a Smack namespace ---
+
+Smack namespace was developed to make it possible for Smack to work
+nicely with Linux containers where there is a full operating system
+with its own init inside the namespace. Such a system working with
+Smack expects to have at least partially working SMACK_MAC_ADMIN to be
+able to change labels of processes and files. This is required to be
+able to securely start applications under the control of Smack and
+manage their access rights.
+
+It was implemented using new LSM hooks added to the user namespace
+that were developed together with Smack namespace.
+
+
+--- Design ideas ---
+
+"Smack namespace" is rather "Smack labels namespace" as not the whole
+MAC is namespaced, only the labels. There is a great analogy between
+Smack labels namespace and the user namespace part that remaps UIDs.
+
+The idea is to create a map of labels for a namespace so the namespace
+is only allowed to use those labels. Smack rules are always the same
+as in the init namespace (limited only by what labels are mapped) and
+cannot be manipulated from the child namespace. The map is actually
+only for labels' names. The underlying structures for labels remain
+the same. The filesystem also stores the "unmapped" labels from the
+init namespace.
+
+Let's say we have those labels in the init namespace:
+label1
+label2
+label3
+
+and those rules:
+label1 label2 rwx
+label1 label3 rwx
+label2 label3 rwx
+
+We create a map for a namespace:
+label1 -> mapped1
+label2 -> mapped2
+
+This means that 'label3' is completely invisible in the namespace. As if
+it didn't exist. All the rules that include it are ignored.
+
+Effectively in the namespace we have only one rule:
+mapped1 mapped2 rwx
+
+Which in reality is:
+label1 label2 rwx
+
+All requests to access an object with a 'label3' will be denied. If it
+ever comes to a situation where 'label3' would have to be printed
+(e.g. reading an exec or mmap label from a file to which we have
+access) then huh sign '?' will be printed instead.
+
+All the operations in the namespace on the remaining labels will have
+to be performed using their mapped names. Things like changing own
+process's label, changing filesystem label. Labels will also be
+printed with their mapped names.
+
+You cannot import new labels in a namespace. Every operation that
+would do so in an init namespace will return an error in the child
+namespace. You cannot assign an unmapped or not existing label to an
+object. You can only operate on labels that have been explicitly
+mapped.
+
+
+--- Capabilities ---
+
+Enabling Smack related capabilities (CAP_MAC_ADMIN and
+CAP_MAC_OVERRIDE) is main goal of Smack namespace, so it can work
+properly in the container. And those capabilities do work to some
+extent. In several places where capabilities are checked compatibility
+with Smack namespace has been introduced. Capabilities are of course
+limited to operate only on mapped labels.
+
+CAP_MAC_OVERRIDE works fully, will allow you to ignore Smack access
+rules, but only between objects that have labels mapped. So in the
+example above having this CAP will allow e.g. label2 to write to
+label1, but will not allow any access to label3.
+
+With CAP_MAC_ADMIN the following operations has been allowed inside
+the namespace:
+- setting and removing xattr on files, including the security.* ones
+- setting process's own label (/proc/self/attr/current)
+- mounting in a privileged Smack mode, which means one can specify
+  additional mount options like: smackfsdef, smackfsfloor etc.
+
+Again this is also allowed only on the mapped labels. Labels on the
+filesystem will be stored in unmapped form so they are preserved
+through reboots.
+
+Such a namespace construct allows e.g. systemd (with Smack support)
+working in a container to assign labels properly to daemons and other
+processes.
+
+
+--- Usage ---
+
+Smack namespace is written using LSM hooks inside user namespace. That
+means it's connected to it.
+
+To create a new Smack namespace you need to unshare() user namespace
+as usual. If that is all you do though, than there is no difference to
+what is now. To activate the Smack namespace you need to fill the
+labels' map. It is in a file /proc/$PID/smack_map.
+
+By default the map is empty and Smack namespaces are inactive (labels
+are taken directly from a parent namespace). It also means that the
+Smack capabilities will be inactive. After you fill the map it starts
+to take effect in the namespace and Smack capabilities (only on mapped
+labels) start to work.
+
+Due to the way Smack works only CAP_MAC_ADMIN from the parent
+namespace (init_user_ns for now, see the "Current limitations" below)
+is allowed to fill the map. That means that an unprivileged user is
+still allowed to create the user namespace but it will not be able to
+fill the labels' map (activate Smack namespace). An administrator
+intervention is required.
+
+The attr_map write format is:
+unmapped_label mapped_label
+
+When reading the file it shows an active map for a namespace the
+process in question is in in the format:
+unmapped_label -> mapped_label
+
+If the smack_map file is empty it means the namespace is not mapped
+and Smack namespace is inactive (no mappings, MAC related capabilities
+behave as they did before, meaning they are active only in
+init_user_ns). For init_user_ns the map will always be empty.
+
+Writing to the map file is not disabled after the first write as it is
+in uid_map. For Smack we have no means to map ranges of labels, hence
+it can really be advantageous to be able to expand the map later
+on. But you can only add to the map. You cannot remove already mapped
+labels. You cannot change the already existing mappings. Also mappings
+has to be 1-1. All requests to create a map where either the unmapped
+or the mapped label already exists in the map will be denied.
+
+setns() with Smack namespace active has an additional check that the
+label of a process that is calling setns() has to be already mapped in
+the target Smack namespace for the call to succeed.
+
+
+--- Special labels ---
+
+Smack is using some special labels that have built-in rules. Things
+like floor '_', dash '^', star '*', etc. Those labels are not
+automatically mapped to the namespace. Moreover, you can choose to map
+a different label from the init namespace to behave e.g. like floor
+inside the namespace.
+
+Let's say we have no rules and those labels in the init namespace:
+_
+floor_to_be
+label
+
+Both 'label' and 'floor_to_be' can read objects with '_'. But they
+have no access rights to each other.
+
+Now let's create a map like this:
+_             ordinary_label
+floor_to_be   _
+label         mapped
+
+Right now label 'mapped' can read label '_' which means that
+effectively inside this namespace label 'label' has gained read access
+to the 'floor_to_be'. The label 'ordinary_label' is exactly it, an
+ordinary label that the built-in rules no longer apply to inside the
+namespace.
+
+To sum up, special labels in the namespace behave the same as in the
+init namespace. Not the original special labels though, but the ones
+we map to specials. This is the only case where a namespace can have
+access rights the init namespace does not have (like the 'label' to
+'floor_to_be' in the example above).
+
+Of course mappings like these are perfectly legal:
+_   _
+*   *
+^   ^
+
+
+--- Current limitations ---
+
+The Smack namespace is not hierarchical yet. It is currently not
+possible to fill a smack_map of a nested user namespace (you can still
+create nested user namespace, it will just inherit its parent's map
+and won't have active Smack capabilities). When hierarchy will be
+implemented the process creating another namespace will be allowed to
+map only labels that it has permission to itself (those that it has in
+its own map).
+
+Special files inside the virtual smackfs needs to be reviewed whether
+it's beneficial to have some of their functionality namespaced as well
+(e.g. onlycap, syslog. ambient, etc). This would increase
+CAP_MAC_ADMIN privileges inside the namespace.
+
+
+--- Error codes ---
+
+While working in the namespace patches the error codes has been made
+to propagate properly from a place they occurred. New error codes has
+also been introduced for Smack in the context of namespace usage. This
+is a complete summary of error codes used throughout the Smack now:
+
+ENOMEM      and other system errors that might come from low level
+            kernel functions like memory allocations
+EOPNOTSUPP  means the underlying system operation is not
+            supported (eg. getxattr)
+EINVAL      means invalid syntax (e.g. empty label or one starting
+            with '-')
+EEXIST      when creating map means that a label is already mapped
+EBADR       is used for wrong namespace usage:
+            - trying to import a label inside a namespace (like trying
+              to use an unmapped label that would otherwise be imported)
+            - trying to create a Smack label map in the init namespace
+ENOENT      when failed to find a label we expected to exist (will not
+            be propagated to user-space)
+EPERM       means no permission to operate on an object, e.g. due to
+            insufficient capabilities or simply because the object
+	    cannot be operated on in the current context
+EACCESS     when access has been denied due to Smack access checks
+            (including object being outside of a namespace)
diff --git a/MAINTAINERS b/MAINTAINERS
index 2e5bbc0..66ab25b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9059,6 +9059,7 @@ W:	http://schaufler-ca.com
 T:	git git://git.gitorious.org/smack-next/kernel.git
 S:	Maintained
 F:	Documentation/security/Smack.txt
+F:	Documentation/security/Smack-namespace.txt
 F:	security/smack/
 
 DRIVERS FOR ADAPTIVE VOLTAGE SCALING (AVS)
diff --git a/security/smack/Kconfig b/security/smack/Kconfig
index b19a7fb..a6e0f3f 100644
--- a/security/smack/Kconfig
+++ b/security/smack/Kconfig
@@ -49,4 +49,6 @@ config SECURITY_SMACK_NS
 	  This enables Smack namespace that makes it possible to map
 	  specific labels within user namespace (analogously to mapping
 	  UIDs) and to gain MAC capabilities over them.
+	  Documentation is availabile here:
+	  Documentation/security/Smack-namespace.txt
 	  If you are unsure how to answer this question, answer N.
-- 
2.1.0
