From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2] userns: Disallow setgroups unless the gid_map writer
	is privileged
Date: Tue, 2 Dec 2014 12:13:32 -0800
Message-ID: <CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87mw75ygwp.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 2, 2014 at 11:45 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>
>> On Tue, Dec 2, 2014 at 4:09 AM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>>
>>>> Classic unix permission checks have an interesting feature.  The
>>>> group permissions for a file can be set to less than the other
>>>> permissions on a file.  Occasionally this is used deliberately to
>>>> give a certain group of users fewer permissions than the default.
>>>>
>>>> User namespaces break this usage.  Groups set in rgid or egid are
>>>> unaffected because an unprivileged user namespace creator can only
>>>> map a single group, so setresgid inside and outside the namespace
>>>> have the same effect.  However, an unprivileged user namespace
>>>> creator can currently use setgroups(2) to drop all supplementary
>>>> groups, so, if a supplementary group denies access to some resource,
>>>> user namespaces can be used to bypass that restriction.
>>>>
>>>> To fix this issue, this introduces a new user namespace flag
>>>> USERNS_SETGROUPS_ALLOWED.  If that flag is not set, then
>>>> setgroups(2) will fail regardless of the caller's capabilities.
>>>>
>>>> USERNS_SETGROUPS_ALLOWED is cleared in a new user namespace.  By
>>>> default, if the writer of gid_map has CAP_SETGID in the parent
>>>> userns and the parent userns has USERNS_SETGROUPS_ALLOWED, then the
>>>> USERNS_SETGROUPS_ALLOWED will be set in the child.  If the writer is
>>>> not so privileged, then writing to gid_map will fail unless the
>>>> writer adds "setgroups deny" to gid_map, in which case the check is
>>>> skipped but USERNS_SETGROUPS_ALLOWED will remain cleared.
>>>>
>>>> The full semantics are:
>>>>
>>>> If "setgroups allow" is present or no explicit "setgroups" setting
>>>> is written to gid_map, then writing to gid_map will fail with -EPERM
>>>> unless the opener and writer have CAP_SETGID in the parent namespace
>>>> and the parent namespace has USERNS_SETGROUPS_ALLOWED.
>>>>
>>>> If "setgroups deny" is present, then writing gid_map will work as
>>>> before, but USERNS_SETGROUPS_ALLOWED will remain cleared.  This will
>>>> result in processes in the userns that have CAP_SETGID to be
>>>> nontheless unable to use setgroups(2).  If this breaks something
>>>> inside the userns, then this is okay -- the userns creator
>>>> specifically requested this behavior.
>>>
>>> I think we need to do this but I also think setgroups allow/deny
>>> should be a separate knob than the uid/gid mapping.
>>
>> Yeah.  It should be readable, too.
>>
>>>
>>> If for no other reason than you missed at least two implementations of
>>> setgroups, in your implementation.
>>
>> I clearly didn't grep hard enough.  Grr.
>>
>>>
>>>> While it could be safe to set USERNS_SETGROUPS_ALLOWED if the user
>>>> namespace creator has no supplementary groups, doing so could be
>>>> surprising and could have unpleasant interactions with setns(2).
>>>>
>>>> Any application that uses newgidmap(1) should be unaffected by this
>>>> fix, but unprivileged users that create user namespaces to
>>>> manipulate mounts or sandbox themselves will break until they start
>>>> using "setgroups deny".
>>>>
>>>> This should fix CVE-2014-8989.
>>>>
>>>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> Signed-off-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>>>> ---
>>>>
>>>> Unlike v1, this *will* break things like Sandstorm.  Fixing them will be
>>>> easy.  I agree that this will result in better long-term semantics, but
>>>> I'm not so happy about breaking working software.
>>>
>>> I know what you mean.   One of the pieces of software broken by all of
>>> this is my test to verify the remount semantics.   Which makes all of
>>> this very unfortunate.
>>>
>>>> If this is unpalatable, here's a different option: get rid of all these
>>>> permission checks and just change setgroups.  Specifically, make it so
>>>> that setgroups(2) in a userns will succeed but will silently refuse to
>>>> remove unmapped groups.
>>>
>>> Nope silently refusing to remove unmapped groups is not enough.  I can
>>> make any gid in my supplemental groups my egid, it takes a sgid helper
>>> application but I don't need any special privileges to create that.
>>> Once that group is my egid I can map it.  Which means I could drop
>>> any one group of my choosing without privielges.  Which out and out
>>> breaks negative groups :(
>>
>> Whoops, right.  And you can, indeed, have egid match one of your
>> supplementary groups.
>>
>>>
>>> I got to looking and I have a significant piece of code that all of this
>>> breaks.
>>>
>>> tools/testing/selftests/mount/unprivileged-remount-test.c
>>>
>>> So I am extra motivated to figure out at find a way to preserve most of
>>> the existing functionality.  My regression tests won't pass until I can
>>> find something pallateable.
>>>
>>> It is very annoying that every option I have considered so far breaks
>>> something useful.
>>>
>>> Having a write once setgroups disable, and the allowing unprivileged
>>> mappings after that seems the most palatable option I have seen,
>>> semantically.  Which means existing software that doesn't care about
>>> setgroups can just add the disable code and then work otherwise
>>> unmodified.
>>>
>>> The other option that I have played with is forcing a set of groups
>>> in setgroups if your user namespace was created without privilege,
>>> that winds up requiring that verify you don't have any other
>>> supplementary groups, and is generally messy whichever way I look at it.
>>
>> How bad would the automatic selection of setgroups behavior really be?
>>
>> Suppose we have /proc/self/userns_setgroups_mode that can be "allow",
>> "deny", or "auto".  It starts out as "auto" (or "deny" if it's set to
>> "deny" in the parent).  Once any of the maps have been set,
>> userns_options becomes readonly.  If you try to write to gid_map when
>> setgroups == auto, then it switches to "allow" or "deny" depending on
>> whether the writer has privilege.
>>
>> This is nasty magical behavior, but it should DTRT for existing users,
>> and everyone can be updated to set the value explicitly.
>
> Rarely is everything updated unless there is a requirement for an
> update.
>
> For my code that cares an update is necessary anyway as it contains
> a gratuitous setgroups(0, NULL).
>
> Since we have to break applications breaking them loud and clear and
> letting them set the flat to recover (if possible) seems the best we can
> do.  That at least allows someone to ask if they depend on setgroups or
> init_groups.

Fair enough.

Any thoughts on what the API should be for v3?

>
>> FWIW, it might also make sense to move all of this stuff into
>> /proc/PID/userns.  There may be races in which a setuid or otherwise
>> privileged helper pokes at more than one userns file but actually
>> modifies different namespaces each time.  I don't know whether these
>> races matter.  uid_map, gid_map, and projid_map could be symlinks.
>
> I don't see how moving these files as removing any races.

It helps if you use openat to open the userns directory and of the
/proc infrastructure is smart enough to make that work.

Admittedly, I don't actually see a dangerous race right now.

--Andy

>
> Eric
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
