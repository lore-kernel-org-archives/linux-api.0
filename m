From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] groups: don't return unmapped gids in getgroups(2)
Date: Fri, 17 Feb 2017 19:44:05 +1100
Message-ID: <84f5d2eb-8686-8acd-8116-038585c97b03@suse.de>
References: <20170216174750.4995-1-asarai@suse.de>
	<87a89mm213.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87a89mm213.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
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
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>> One thing overlooked by commit 9cc46516ddf4 ("userns: Add a knob to
>> disable setgroups on a per user namespace basis") is that because
>> setgroups(2) no longer works in user namespaces it doesn't make any
>> sense to be returning weird group IDs that the process cannot do
>> anything with.
>
> This code works the same weather or not setgroups is enabled.

Yes. Sorry, I explain the reasoning for this better below. But the point 
is that "65534" is ambiguous in this context and can lead to confusion 
for a userspace program.

However, you have a point that when setgroups is enabled then this code 
will effectively hide groups which the process may wish to drop. I'm not 
sure what you would like to do in this instance -- but I'd prefer if we 
first agree on whether this is a worthwhile issue to solve in the kernel 
or if userspace should just hack around it (which I've already partially 
done[1]).

>> This change, along with the other changes made to require unprivileged
>> users to always disable setgroups(2), means that userspace programs such
>> as apt break inside rootless containers. While this change does change
>> the userspace ABI, any userspace program that has to deal with
>> getgroups(2) would have to filter out these "fake" group IDs anyway.
>> This just makes it so that less applications will have to handle this
>> broken API.
>
> Is it broken?  Unless I am mistaken if we have a 16bit getgroups
> call and we 32bit group ids  getgroups it behaves exactly the same way.

When I say "broken" what I mean is that getgroups(2) is telling 
userspace that "you are a member of group 65534". But you now have two 
different (confusing) cases that can result:

1. That group is not mapped. Which means that anything that application 
assumes about getgroups(2) returning sane results now needs to be 
cross-checked with /proc/self/uid_map and checking whether setgroups 
will actually work. Apt is an example of such a program -- it attempts 
to drop all privileges using setgroups(2) because getgroups(2) tells it 
that has some supplementary groups.

2. That group _is_ mapped. Now the application has no way of knowing 
whether it actually is in group 65534 (aside from experimenting with 
files and trying to see what its _actual_ groups are).

Note that in both cases it is not simple to be completely sure whether 
the 65534 that getgroups(2) returned actually means "unmapped" or

> The value we is (u16)-2.  The traditional linux group id for this
> purpose.

Okay, but 65534 is a valid group ID as well. So while in principle it's 
reserved for this purpose, returning an "invalid" group ID that is 
actually a valid value is just confusing.

> In all other contexts the best we can do for applications has been to
> return the user id or group id that says the value you are looking for
> does not fit in this context.  Which makes me suspect this is not the
> right solution for getgroups.

While with getuid() and getgid() I understand this logic (though I 
strongly feel there should be an EUNMAPPED, I understand why it doesn't 
exist). With get{u,g}id() there is an implicit statement that 
overflow_{u,g}id should be semantically equivalent to "unmapped {U,G}ID".

However, this doesn't (IMO) apply to getgroups(2). getgroups(2) tells 
you what groups you are a member of, and there is a semantic difference 
to "you are a member of group #overflow_gid" and "you are in an unmapped 
group".

> I don't know why apt breaks.  You have not described that.  Perhaps apt
> is seeing something misconfigured and complaining properly.


I investigated this quite a bit while trying to get rootless containers 
to work with runC. After reading the code again, apt actually does two 
things:

1. Unconditionally does setgroups(1, &some_gid). This obviously breaks 
in rootless containers, but can be fixed.

2. It then has some checks to verify that it has dropped privileges 
correctly. Now, you _can_ disable these checks but I would prefer not to 
(many other programs have similar code to make sure they are safely 
dropping privileges). If you look in apt-pkg/contrib/fileutl.cc you'll 
see this [abbreviated] function:

bool DropPrivileges()
{
	/* ... */
       // Verify that the user isn't still in any supplementary groups
       long const ngroups_max = sysconf(_SC_NGROUPS_MAX);
       std::unique_ptr<gid_t[]> gidlist(new gid_t[ngroups_max]);
       if (unlikely(gidlist == NULL))
	 return _error->Error("Allocation of a list of size %lu for getgroups 
failed", ngroups_max);
       ssize_t gidlist_nr;
       if ((gidlist_nr = getgroups(ngroups_max, gidlist.get())) < 0)
	 return _error->Errno("getgroups", "Could not get new groups (%lu)", 
ngroups_max);
       for (ssize_t i = 0; i < gidlist_nr; ++i)
	 if (gidlist[i] != pw->pw_gid)
	    return _error->Error("Could not switch group, user %s is still in 
group %d", toUser.c_str(), gidlist[i]);
	/* ... */
}

Which will fail in rootless containers, and there's nothing you can do 
as a user other than disable the checks and modify the apt source code. 
There are almost certainly more examples (searching github found things 
like qmail also appear to have some similar logic, and I think some 
components of Varnish might too).

Also, I found that this "secure coding standards" document recommends 
this sort of practice when writing software that needs to drop 
privileges[2]. I'm sure there exists plenty of userspace software which 
implements this kind of logic.

The reason you haven't seen bug reports (or people shouting on the ML) 
for this is that people are still not really running rootless containers 
yet -- the work I'm doing in runC is what's uncovering these sorts of 
issues.

> I can be persauded but I need a better argument than this change makes
> one applicaiton work for me.

I need to get better at writing commit messages, sorry about that. As I 
mentioned above, the biggest issue is the ambiguity of 65534. The fact 
that apt doesn't react in a sane way is a symptom of that issue, and 
there are almost certainly more cases of programs that act in this way.

[1]: https://github.com/cyphar/remainroot
[2]: 
https://www.securecoding.cert.org/confluence/display/c/POS36-C.+Observe+correct+revocation+order+while+relinquishing+privileges

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
