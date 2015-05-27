From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v2 0/7] Smack namespace
Date: Tue, 26 May 2015 22:13:34 -0500
Message-ID: <87h9qyww4h.fsf@x220.int.ebiederm.org>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
	<1432557162-19123-1-git-send-email-l.pawelczyk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1432557162-19123-1-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
	(Lukasz Pawelczyk's message of "Mon, 25 May 2015 14:32:35 +0200")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, John Johansen <john.johansen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rafal Krypa <r.krypa-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Oleg
List-Id: linux-api@vger.kernel.org

Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> writes:

> Hello,
>
> Some time ago I sent a Smack namespace documentation and a preliminary
> LSM namespace for RFC. I've been suggested that there shouldn't be a
> separate LSM namespace and that it should live within user namespace.
> And this version does. This is a complete set of patches required for
> Smack namespace.
>
> This was designed with a collaboration of Smack maintainer Casey
> Schaufler.
>
> Smack namespace have been implemented using user namespace hooks added
> by one of the patches. To put some context to it I paste here a
> documentation on what Smack namespace wants to achieve.
>
> LSM hooks themselves are documented in the security.h file inside the
> patch.
>
> The patches are based on:
> https://github.com/cschaufler/smack-next/tree/smack-for-4.2-stacked
>
> The tree with them is avaiable here:
> https://github.com/Havner/smack-namespace/tree/smack-namespace-for-4.2-stacked-v2
>
> Changes from v1:
>  - "kernel/exit.c: make sure current's nsproxy != NULL while checking
>    caps" patch has been dropped
>  - fixed the title of the user_ns operations patch

A have not completed a review I don't understand smack well enough to
answer some questions but I don't think I like the approach this patch
takes to get things done.

I am flattered that you are using a mapping as I did with uid map and
gid map.  Unfortunately I do not believe your mapping achieves what my
mapping of uids and gids achieved.

A technical goal is to give people the tools so that a sysadmin can set
up a system, can grant people subids and subgids, and then the user can
proceed to do what they need to do.  In particular there should be
little to no need to keep pestering the system administrator for more
identifiers.

The flip side of that was that the mapping would ensure all of the
existing permissions checks would work as expected, and the checks in
the kernel could be converted without much trouble.

Ranges of ids were choosen because they allow for a lot of possible ways
of using uids and gids in containers, are comparitively easy to
administer, are very fast to use, and don't need large data structures.

With a discreet mapping of labels I have the premonition that we now
have a large data structure that, is not as flexible in to use,
is comparatively slow and appears to require an interaction with the
system administrator for every label you use in a container.

As part of that there is added a void *security pointer in the user
namespace to apparently hang off anything anyone would like to use.
Connected to that are hooks that have failure codes (presumably memory
allocation failures), but the semantics are not clear.  My gut feel is
that I would rather extend struct user_namespace to hold the smack label
mapping table and remove all of the error codes because they would then
be unnecessary.

I am also concerned that several of the operations assume that setns
and the like are normally privileged operations and so require the
ability to perform other privileged operations.  Given that in the right
circumstances setns is not privileged that seems like a semantics
mismatch.

Or in short my gut feel says the semantics of this change are close to
something that would be very useful, but the details make this patchset
far less useful, usable and comprehensible than it should be.

Eric


> ===================================================================
>
> --- What is a Smack namespace ---
>
> Smack namespace was developed to make it possible for Smack to work
> nicely with Linux containers where there is a full operating system
> with its own init inside the namespace. Such a system working with
> Smack expects to have at least partially working SMACK_MAC_ADMIN to be
> able to change labels of processes and files. This is required to be
> able to securely start applications under the control of Smack and
> manage their access rights.
>
> It was implemented using new LSM hooks added to the user namespace
> that were developed together with Smack namespace.
>
>
> --- Design ideas ---
>
> "Smack namespace" is rather "Smack labels namespace" as not the whole
> MAC is namespaced, only the labels. There is a great analogy between
> Smack labels namespace and the user namespace part that remaps UIDs.
>
> The idea is to create a map of labels for a namespace so the namespace
> is only allowed to use those labels. Smack rules are always the same
> as in the init namespace (limited only by what labels are mapped) and
> cannot be manipulated from the child namespace. The map is actually
> only for labels' names. The underlying structures for labels remain
> the same. The filesystem also stores the "unmapped" labels from the
> init namespace.
>
> Let's say we have those labels in the init namespace:
> label1
> label2
> label3
>
> and those rules:
> label1 label2 rwx
> label1 label3 rwx
> label2 label3 rwx
>
> We create a map for a namespace:
> label1 -> mapped1
> label2 -> mapped2
>
> This means that 'label3' is completely invisible in the namespace. As if
> it didn't exist. All the rules that include it are ignored.
>
> Effectively in the namespace we have only one rule:
> mapped1 mapped2 rwx
>
> Which in reality is:
> label1 label2 rwx
>
> All requests to access an object with a 'label3' will be denied. If it
> ever comes to a situation where 'label3' would have to be printed
> (e.g. reading an exec or mmap label from a file to which we have
> access) then huh sign '?' will be printed instead.
>
> All the operations in the namespace on the remaining labels will have
> to be performed using their mapped names. Things like changing own
> process's label, changing filesystem label. Labels will also be
> printed with their mapped names.
>
> You cannot import new labels in a namespace. Every operation that
> would do so in an init namespace will return an error in the child
> namespace. You cannot assign an unmapped or not existing label to an
> object. You can only operate on labels that have been explicitly
> mapped.
>
>
> --- Capabilities ---
>
> Enabling Smack related capabilities (CAP_MAC_ADMIN and
> CAP_MAC_OVERRIDE) is main goal of Smack namespace, so it can work
> properly in the container. And those capabilities do work to some
> extent. In several places where capabilities are checked compatibility
> with Smack namespace has been introduced. Capabilities are of course
> limited to operate only on mapped labels.
>
> CAP_MAC_OVERRIDE works fully, will allow you to ignore Smack access
> rules, but only between objects that have labels mapped. So in the
> example above having this CAP will allow e.g. label2 to write to
> label1, but will not allow any access to label3.
>
> With CAP_MAC_ADMIN the following operations has been allowed inside
> the namespace:
> - setting and removing xattr on files, including the security.* ones
> - setting process's own label (/proc/self/attr/current)
> - mounting in a privileged Smack mode, which means one can specify
>   additional mount options like: smackfsdef, smackfsfloor etc.
>
> Again this is also allowed only on the mapped labels. Labels on the
> filesystem will be stored in unmapped form so they are preserved
> through reboots.
>
> Such a namespace construct allows e.g. systemd (with Smack support)
> working in a container to assign labels properly to daemons and other
> processes.
>
>
> --- Usage ---
>
> Smack namespace is written using LSM hooks inside user namespace. That
> means it's connected to it.
>
> To create a new Smack namespace you need to unshare() user namespace
> as usual. If that is all you do though, than there is no difference to
> what is now. To activate the Smack namespace you need to fill the
> labels' map. It is in a file /proc/$PID/smack_map.
>
> By default the map is empty and Smack namespaces are inactive (labels
> are taken directly from a parent namespace). It also means that the
> Smack capabilities will be inactive. After you fill the map it starts
> to take effect in the namespace and Smack capabilities (only on mapped
> labels) start to work.
>
> Due to the way Smack works only CAP_MAC_ADMIN from the parent
> namespace (init_user_ns for now, see the "Current limitations" below)
> is allowed to fill the map. That means that an unprivileged user is
> still allowed to create the user namespace but it will not be able to
> fill the labels' map (activate Smack namespace). An administrator
> intervention is required.
>
> The attr_map write format is:
> unmapped_label mapped_label
>
> When reading the file it shows an active map for a namespace the
> process in question is in in the format:
> unmapped_label -> mapped_label
>
> If the smack_map file is empty it means the namespace is not mapped
> and Smack namespace is inactive (no mappings, MAC related capabilities
> behave as they did before, meaning they are active only in
> init_user_ns). For init_user_ns the map will always be empty.
>
> Writing to the map file is not disabled after the first write as it is
> in uid_map. For Smack we have no means to map ranges of labels, hence
> it can really be advantageous to be able to expand the map later
> on. But you can only add to the map. You cannot remove already mapped
> labels. You cannot change the already existing mappings. Also mappings
> has to be 1-1. All requests to create a map where either the unmapped
> or the mapped label already exists in the map will be denied.
>
> setns() with Smack namespace active has an additional check that the
> label of a process that is calling setns() has to be already mapped in
> the target Smack namespace for the call to succeed.
>
> --- Special labels ---
>
> Smack is using some special labels that have built-in rules. Things
> like floor '_', dash '^', star '*', etc. Those labels are not
> automatically mapped to the namespace. Moreover, you can choose to map
> a different label from the init namespace to behave e.g. like floor
> inside the namespace.
>
> Let's say we have no rules and those labels in the init namespace:
> _
> floor_to_be
> label
>
> Both 'label' and 'floor_to_be' can read objects with '_'. But they
> have no access rights to each other.
>
> Now let's create a map like this:
> _             ordinary_label
> floor_to_be   _
> label         mapped
>
> Right now label 'mapped' can read label '_' which means that
> effectively inside this namespace label 'label' has gained read access
> to the 'floor_to_be'. The label 'ordinary_label' is exactly it, an
> ordinary label that the built-in rules no longer apply to inside the
> namespace.
>
> To sum up, special labels in the namespace behave the same as in the
> init namespace. Not the original special labels though, but the ones
> we map to specials. This is the only case where a namespace can have
> access rights the init namespace does not have (like the 'label' to
> 'floor_to_be' in the example above).
>
> Of course mappings like these are perfectly legal:
> _   _
> *   *
> ^   ^
>
>
> --- Current limitations ---
>
> The Smack namespace is not hierarchical yet. It is currently not
> possible to fill a smack_map of a nested user namespace (you can still
> create nested user namespace, it will just inherit its parent's map
> and won't have active Smack capabilities). When hierarchy will be
> implemented the process creating another namespace will be allowed to
> map only labels that it has permission to itself (those that it has in
> its own map).

> Special files inside the virtual smackfs needs to be reviewed whether
> it's beneficial to have some of their functionality namespaced as well
> (e.g. onlycap, syslog. ambient, etc). This would increase
> CAP_MAC_ADMIN privileges inside the namespace.
>
>
> Lukasz Pawelczyk (7):
>   user_ns: 3 new hooks for user namespace operations
>   smack: extend capability functions and fix 2 checks
>   smack: abstraction layer for 2 common Smack operations
>   smack: misc cleanups in preparation for a namespace patch
>   smack: namespace groundwork
>   smack: namespace implementation
>   smack: documentation for the Smack namespace
>
>  Documentation/security/00-INDEX            |   2 +
>  Documentation/security/Smack-namespace.txt | 231 +++++++++++++
>  MAINTAINERS                                |   1 +
>  fs/proc/base.c                             |  57 +++
>  include/linux/lsm_hooks.h                  |  28 ++
>  include/linux/security.h                   |  23 ++
>  include/linux/user_namespace.h             |   9 +
>  kernel/user.c                              |   3 +
>  kernel/user_namespace.c                    |  18 +
>  security/security.c                        |  28 ++
>  security/smack/Kconfig                     |  12 +
>  security/smack/Makefile                    |   1 +
>  security/smack/smack.h                     | 187 +++++++++-
>  security/smack/smack_access.c              | 191 ++++++++--
>  security/smack/smack_lsm.c                 | 536 ++++++++++++++++++++---------
>  security/smack/smack_ns.c                  | 471 +++++++++++++++++++++++++
>  security/smack/smackfs.c                   | 154 +++++----
>  17 files changed, 1702 insertions(+), 250 deletions(-)
>  create mode 100644 Documentation/security/Smack-namespace.txt
>  create mode 100644 security/smack/smack_ns.c
