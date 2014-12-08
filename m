From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CFT][PATCH 2/7] userns: Don't allow setgroups until a gid
	mapping has been setablished
Date: Mon, 08 Dec 2014 16:39:30 -0600
Message-ID: <874mt5ojfh.fsf@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>
	<CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
	<87a935u3nj.fsf@x220.int.ebiederm.org>
	<CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
	<87388xodlj.fsf@x220.int.ebiederm.org>
	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>
	<87bnndre2h.fsf_-_@x220.int.ebiederm.org> <5486237D.4060304@nod.at>
	<CALCETrXSG5QN8J3GtZjLdV6T7j_uaMG=fyTDt27vEK0NpGs9qg@mail.gmail.com>
	<548625E3.6020400@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <548625E3.6020400-/L3Ra7n9ekc@public.gmane.org> (Richard Weinberger's message of "Mon,
	08 Dec 2014 23:27:47 +0100")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org> writes:

> Am 08.12.2014 um 23:25 schrieb Andy Lutomirski:
>> On Mon, Dec 8, 2014 at 2:17 PM, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org> wrote:
>>> Am 08.12.2014 um 23:07 schrieb Eric W. Biederman:
>>>>
>>>> setgroups is unique in not needing a valid mapping before it can be called,
>>>> in the case of setgroups(0, NULL) which drops all supplemental groups.
>>>>
>>>> The design of the user namespace assumes that CAP_SETGID can not actually
>>>> be used until a gid mapping is established.  Therefore add a helper function
>>>> to see if the user namespace gid mapping has been established and call
>>>> that function in the setgroups permission check.
>>>>
>>>> This is part of the fix for CVE-2014-8989, being able to drop groups
>>>> without privilege using user namespaces.
>>>>
>>>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>  include/linux/user_namespace.h | 9 +++++++++
>>>>  kernel/groups.c                | 7 ++++++-
>>>>  2 files changed, 15 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
>>>> index e95372654f09..41cc26e5a350 100644
>>>> --- a/include/linux/user_namespace.h
>>>> +++ b/include/linux/user_namespace.h
>>>> @@ -37,6 +37,15 @@ struct user_namespace {
>>>>
>>>>  extern struct user_namespace init_user_ns;
>>>>
>>>> +static inline bool userns_gid_mappings_established(const struct user_namespace *ns)
>>>> +{
>>>> +     bool established;
>>>> +     smp_mb__before_atomic();
>>>> +     established = ACCESS_ONCE(ns->gid_map.nr_extents) != 0;
>>>> +     smp_mb__after_atomic();
>>>> +     return established;
>>>> +}
>>>> +
>>>
>>> Maybe this is a stupid question, but why do we need all this magic
>>> around established =  ... ?
>>> The purpose of this code is to check whether ns->gid_map.nr_extents != 0
>>> in a lock-free manner?
>>>
>> 
>> See my other comment -- the ordering will matter at the end of the series.
>
> But ns->gid_map.nr_extents is not atomic, it is a plain u32.
> This confuses me.

Read Documentation/atomic_ops.txt a plain u32 is atomic by definiton.

Which is a little bit convoluted.  However that is part of the of the
gid mapping path and I optimized that as far as I humanly could so that
calls like stat don't take a noticable slow donw.

On this path we don't particularly care except that I am using an the
existing data structure.

Eric
