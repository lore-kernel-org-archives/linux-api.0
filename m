From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [RFC PATCH ghak32 V2 11/13] audit: add support for containerid to
	network namespaces
Date: Sat, 21 Apr 2018 08:10:46 -0400
Message-ID: <162e81d2170.280e.85c95baa4474aabc7814e68940a78392@paul-moore.com>
References: <cover.1521179281.git.rgb@redhat.com>
	<11b43a498e768a14764594c808a96b34d52be0af.1521179281.git.rgb@redhat.com>
	<CAHC9VhRkstDMjd5T3w+iOUDjzDAs1AOm0xd3p6v_xn6fNGYQhA@mail.gmail.com>
	<20180420200226.7tyxzuovdbgclw3m@madcap2.tricolour.ca>
	<CAHC9VhTOYUAyCJidm99som6FVmjouQUGsEHarQ4h_NhwJxQQfw@mail.gmail.com>
	<20180420204225.iik2lgtj6gx2ep4w@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180420204225.iik2lgtj6gx2ep4w-bcJWsdo4jJjeVoXN4CMphl7TgLCtbB0G@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On April 20, 2018 4:48:34 PM Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
On 2018-04-20 16:22, Paul Moore wrote:
On Fri, Apr 20, 2018 at 4:02 PM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
On 2018-04-18 21:46, Paul Moore wrote:
On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
Audit events could happen in a network namespace outside of a task
context due to packets received from the net that trigger an auditing
rule prior to being associated with a running task.  The network
namespace could in use by multiple containers by association to the
tasks in that network namespace.  We still want a way to attribute
these events to any potential containers.  Keep a list per network
namespace to track these container identifiiers.

Add/increment the container identifier on:
- initial setting of the container id via /proc
- clone/fork call that inherits a container identifier
- unshare call that inherits a container identifier
- setns call that inherits a container identifier
Delete/decrement the container identifier on:
- an inherited container id dropped when child set
- process exit
- unshare call that drops a net namespace
- setns call that drops a net namespace

See: https://github.com/linux-audit/audit-kernel/issues/32
See: https://github.com/linux-audit/audit-testsuite/issues/64
Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
include/linux/audit.h       |  7 +++++++
include/net/net_namespace.h | 12 ++++++++++++
kernel/auditsc.c            |  9 ++++++---
kernel/nsproxy.c            |  6 ++++++
net/core/net_namespace.c    | 45 +++++++++++++++++++++++++++++++++++++++++++++
5 files changed, 76 insertions(+), 3 deletions(-)

...

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f6c5d33..d9f1090 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -140,6 +140,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
struct nsproxy *old_ns = tsk->nsproxy;
struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
struct nsproxy *new_ns;
+       u64 containerid = audit_get_containerid(tsk);

if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
CLONE_NEWPID | CLONE_NEWNET |
@@ -167,6 +168,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
return  PTR_ERR(new_ns);

tsk->nsproxy = new_ns;
+       net_add_audit_containerid(new_ns->net_ns, containerid);
return 0;
}

Hopefully we can handle this in audit_net_init(), we just need to
figure out where we can get the correct task_struct for the audit
container ID (some backpointer in the net struct?).

I don't follow.  This needs to happen on every task startup.
audit_net_init() is only called when a new network namespace starts up.

Yep, sorry, my mistake.  I must have confused myself when I was
looking at the code.

I'm thinking out loud here, bear with me ...

Assuming we move the netns/audit-container-ID tracking to audit_net,
and considering we already have an audit hook in copy_process() (it
calls audit_alloc()), would this be better handled by the
copy_process() hook?  This ignores naming, audit_alloc() reuse, etc.;
those can be easily fixed.  I'm just thinking of ways to limit our
impact on the core kernel and leverage our existing interaction
points.

The new namespace hasn't been cloned yet and this is the only function
where we have access to both namespaces, so I don't see how that could
work...

I'll take another, closer look, with v3.


paul moore

- RGB

--
Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635


--
paul moore
www.paul-moore.com
