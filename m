From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] simplified security.nscapability xattr
Date: Tue, 10 May 2016 14:00:06 -0500
Message-ID: <20160510190006.GA3456@mail.hallyn.com>
References: <1461345993-17526-1-git-send-email-serge.hallyn@ubuntu.com>
	<1461345993-17526-2-git-send-email-serge.hallyn@ubuntu.com>
	<CAGXu5jKFNQs8oxq+yD6_Q8HcNyf+GouSHFzkxT9u9BkK=ZLQ7Q@mail.gmail.com>
	<20160426222627.GA19307@mail.hallyn.com>
	<CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
	<20160502035452.GA31837@mail.hallyn.com>
	<87h9egp2oq.fsf@x220.int.ebiederm.org>
	<CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
	<874mafiw2m.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <874mafiw2m.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> 
> > On 2 May 2016 6:04 p.m., "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> > wrote:
> >>
> >> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> >>
> >> > On Tue, Apr 26, 2016 at 03:39:54PM -0700, Kees Cook wrote:
> >> >> On Tue, Apr 26, 2016 at 3:26 PM, Serge E. Hallyn
> > <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> >> >> > Quoting Kees Cook (keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org):
> >> >> >> On Fri, Apr 22, 2016 at 10:26 AM, <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> > wrote:
> >> >> >> > From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> >> > ...
> >> >> >> This looks like userspace must knowingly be aware that it is
> > in a
> >> >> >> namespace and to DTRT instead of it being translated by the
> > kernel
> >> >> >> when setxattr is called under !init_user_ns?
> >> >> >
> >> >> > Yes - my libcap2 patch checks /proc/self/uid_map to decide
> > that. If that
> >> >> > shows you are in init_user_ns then it uses security.capability,
> > otherwise
> >> >> > it uses security.nscapability.
> >> >> >
> >> >> > I've occasionally considered having the xattr code do the quiet
> >> >> > substitution if need be.
> >> >> >
> >> >> > In fact, much of this structure comes from when I was still
> > trying to
> >> >> > do multiple values per xattr. Given what we're doing here, we
> > could
> >> >> > keep the xattr contents exactly the same, just changing the
> > name.
> >> >> > So userspace could just get and set security.capability; if you
> > are
> >> >> > in a non-init user_ns, if security.capability is set then you
> > cannot
> >> >> > set it; if security.capability is not set, then the kernel
> > writes
> >> >> > security.nscapability instead and returns success.
> >> >> >
> >> >> > I don't like magic, but this might be just straightforward
> > enough
> >> >> > to not be offensive. Thoughts?
> >> >>
> >> >> Yeah, I think it might be better to have the magic in this case,
> > since
> >> >> it seems weird to just reject setxattr if a tool didn't realize
> > it was
> >> >> in a namespace. I'm not sure -- it is also nice to have an
> > explicit
> >> >> API here.
> >> >>
> >> >> I would defer to Eric or Michael on that. I keep going back and
> > forth,
> >> >> though I suspect it's probably best to do what you already have
> >> >> (explicit API).
> >> >
> >> > Michael, Eric, what do you think? The choice we're making here is
> >> > whether we should
> >> >
> >> > 1. Keep a nice simple separate pair of xattrs, the pre-existing
> >> > security.capability which can only be written from init_user_ns,
> >> > and the new (in this patch) security.nscapability which you can
> >> > write to any file where you are privileged wrt the file.
> >> >
> >> > 2. Make security.capability somewhat 'magic' - if someone in a
> >> > non-initial user ns tries to write it and has privilege wrt the
> >> > file, then the kernel silently writes security.nscapability
> > instead.
> >> >
> >> > The biggest drawback of (1) would be any tar-like program trying
> >> > to restore a file which had security.capability, needing to know
> >> > to detect its userns and write the security.nscapability instead.
> >> > The drawback of (2) is ~\o/~ magic.
> >>
> >> Apologies for not having followed this more closely before.
> >>
> >> I don't like either option. I think we will be in much better shape
> > if
> >> we upgrade the capability xattr. It seems totally wrong or at least
> >> confusing for a file to have both capability xattrs.
> >>
> >> Just using security.capability allows us to confront any weird
> > issues
> >> with mixing both the old semantics and the new semantics.
> >>
> >> We had previously discussioned extending the capbility a little and
> >> adding a uid who needed to be the root uid in a user namespace, to
> > be
> >> valid. Using the owner of the file seems simpler, and even a little
> >> more transparent as this makes the security.capability xattr a
> > limited
> >> form of setuid (which it semantically is).
> >>
> >> So I believe the new semantics in general are an improvement.
> >>
> >>
> >> Given the expected use case let me ask as simple question: Are there
> > any
> >> known cases where the owner of a setcap exectuable is not root?
> >>
> >> I expect the pile of setcap exectuables is small enough we can go
> >> through the top distros and look at all of the setcap executlables.
> >>
> >>
> >> If there is not a need to support setcap executables owned by
> > non-root,
> >> I suspect the right play is to just change the semantics to always
> > treat
> >> the security.capability attribute this way.
> >>
> >
> > I guess I'm confused how we have strayed so far that this isn't an
> > obvious requirement. Uid=0 as being the root of privilege was the
> > basic problem that capabilities were designed to change.
> 
> uid==0 as the owner of a file is slightly different from uid==0 of a
> running process.  Last I checked if it is installed as part of a
> distribution the programs are owned by root by default.

Note that this does mean that a user namespace without a mapping for a
uid 0 cannot use file capabilities.

But I'm not sure there is a way around that.  Even if we store the
userns identifier in an xattr instead of using the file owner, we still
need to uniquely identify the namespace somehow, and as Jann pointed
out using the namespace creator uid is non-ideal as it means all namespaces
even with disjoint uid mappings can mess with each other.

> > Uid is an acl concept. Capabilities are supposed to be independent of
> > that.
> 
> I don't have a clue what you mean.  Posix capabilities on executables
> are part of discretionary access control.  Whatever their rules posix
> capabilities are just watered down versions of the permissions of
> a setuid root exectuable.  I don't think anyone has ever actually run a
> system with setuid root exectuables not being special.  If you are

I actually suspect Andrew does, and I've done it though only as an
experiment.  (Oh - but I may mean something different than what you
mean, see below)

> thinking of what any other system call capabilities unix calls those are
> file descriptors.
> 
> I don't think it is necessarily wrong that files that hold exectuable
> programs need to be owned by a user that is trusted to install files
> system wide.  So far that user in my limited sampling that user is
> always root.  Given that installing a program like that is fundamentally
> a very privileged role we may not be able to break it up successfully,
> so root as the owner of program files seems to make a lot of sense.
> 
> How would you design a system wide program installer in a root less
> system?

The root id is still special, in the same sense as it is in plan 9 - it
is the uid which "owns" the hardware.  In linux setuid always still
works - it just can be configured to not raise/drop privileges on
setuid.  (You know all this, but someone reading along may have
forgotten)

The question then is what it should take to set and to use a file
capability.

So what we have right now is afaics a technical roadblock - in that I
really can't see a way to safely allow filecaps in a userns without a
uid 0 mapping.  It's unfortunate, and it's not a goal, it's an implementation
detail.  I personally think it is a huge improvement over what we have.
The question is does doing it this way now prevent us from doing it
the right way later if we can find a right way?

> Does anyone know any linux based system that uses file capabilities on
> executables without setting the executable to be owned by root?  One
> example would be all that it takes to shut down this marvelous
> simplification that I see.
> 
> 
> I strongly suspect the reality is that all that exists are watered down
> setuid root exectuables.  If that is indeed the case we can safely let
> file caps only be valid if root owns the file.  That would be convinient
> at it is much simpler to understand and implement and audit.
> 
> 
> I really don't care either way except that I like simpler code, and I
> like not breaking userspace.
> 
> Eric
