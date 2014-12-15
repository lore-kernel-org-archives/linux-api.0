From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [CFT] Can I get some Tested-By's on this series?
Date: Mon, 15 Dec 2014 19:38:38 +0000
Message-ID: <20141215193838.GB28375@ubuntumail>
References: <87ppbtn4mv.fsf@x220.int.ebiederm.org>
	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
	<87a92xn2io.fsf@x220.int.ebiederm.org>
	<87r3w8liw4.fsf@x220.int.ebiederm.org>
	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>
	<87mw6vh31e.fsf_-_@x220.int.ebiederm.org>
	<20141210224822.GG20012@ubuntumail>
	<87lhmcy2et.fsf@x220.int.ebiederm.org>
	<20141212220840.GF22091@castiana.ipv6.teksavvy.com>
	<8761dgze56.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8761dgze56.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> St=E9phane Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
> =

> > On Fri, Dec 12, 2014 at 03:38:18PM -0600, Eric W. Biederman wrote:
> >> Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
> >> =

> >> > Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> >> >> =

> >> >> Will people please test these patches with their container project?
> >> >> =

> >> >> These changes break container userspace (hopefully in a minimal way=
) if
> >> >> I could have that confirmed by testing I would really appreciate it=
.  I
> >> >> really don't want to send out a bug fix that accidentally breaks
> >> >> userspace again.
> >> >> =

> >> >> The only issue sort of under discussion is if there is a better nam=
e for
> >> >> /proc/<pid>/setgroups, and the name of the file will not affect the
> >> >> functionality of the patchset.
> >> >> =

> >> >> With the code reviewed and written in simple obviously correct, eas=
ily
> >> >> reviewable ways I am hoping/planning to send this to Linus ASAP.
> >> >> =

> >> >> Eric
> >> >
> >> > Is there a git tree we can clone?
> >> =

> >> Have either of you been able to check to see if any of my changes
> >> affects lxc?
> >> =

> >> I am trying to gauge how hard and how fast I should push to Linus.  lxc
> >> being the largest adopter of unprivileged user namespaces for general
> >> purpose containers.
> >> =

> >> I expect you just call newuidmap and newgidmap and don't actually care
> >> about not being able to set gid_map without privilege.  But I really
> >> want to avoid pushing a security fix and then being surprised that
> >> things like lxc break.
> >> =

> >> Eric
> >
> > Hi Eric,
> >
> > I've unfortunately been pretty busy this week as I was (well, still am)
> > travelling to South Africa for a meeting. I don't have a full kernel
> > tree around here and a full git clone isn't really doable over the kind
> > of Internet I've got here :)
> >
> > Hopefully Serge can give it a quick try, otherwise I should be able to
> > do some tests on Tuesday when I'm back home.
> =

> I thought Serge was going to but I haven't heard yet so I am prodding ;-)

Ok, thanks - yes, unprivileged lxc is working fine with your kernels.
Just to be sure I was testing the right thing I also tested using
my unprivileged nsexec testcases, and they failed on setgroup/setgid
as now expected, and succeeded there without your patches.

thanks,
-serge
