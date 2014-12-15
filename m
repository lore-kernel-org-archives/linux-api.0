From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [CFT] Can I get some Tested-By's on this series?
Date: Mon, 15 Dec 2014 20:49:30 +0000
Message-ID: <20141215204930.GD28877@ubuntumail>
References: <87a92xn2io.fsf@x220.int.ebiederm.org>
 <87r3w8liw4.fsf@x220.int.ebiederm.org>
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org>
 <87mw6vh31e.fsf_-_@x220.int.ebiederm.org>
 <20141210224822.GG20012@ubuntumail>
 <87lhmcy2et.fsf@x220.int.ebiederm.org>
 <20141212220840.GF22091@castiana.ipv6.teksavvy.com>
 <8761dgze56.fsf@x220.int.ebiederm.org>
 <20141215193838.GB28375@ubuntumail>
 <8761dcwu40.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8761dcwu40.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
>=20
> > Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> >> St=E9phane Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
> >>=20
> >> > On Fri, Dec 12, 2014 at 03:38:18PM -0600, Eric W. Biederman wrot=
e:
> >> >> Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
> >> >>=20
> >> >> > Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> >> >> >>=20
> >> >> >> Will people please test these patches with their container p=
roject?
> >> >> >>=20
> >> >> >> These changes break container userspace (hopefully in a mini=
mal way) if
> >> >> >> I could have that confirmed by testing I would really apprec=
iate it.  I
> >> >> >> really don't want to send out a bug fix that accidentally br=
eaks
> >> >> >> userspace again.
> >> >> >>=20
> >> >> >> The only issue sort of under discussion is if there is a bet=
ter name for
> >> >> >> /proc/<pid>/setgroups, and the name of the file will not aff=
ect the
> >> >> >> functionality of the patchset.
> >> >> >>=20
> >> >> >> With the code reviewed and written in simple obviously corre=
ct, easily
> >> >> >> reviewable ways I am hoping/planning to send this to Linus A=
SAP.
> >> >> >>=20
> >> >> >> Eric
> >> >> >
> >> >> > Is there a git tree we can clone?
> >> >>=20
> >> >> Have either of you been able to check to see if any of my chang=
es
> >> >> affects lxc?
> >> >>=20
> >> >> I am trying to gauge how hard and how fast I should push to Lin=
us.  lxc
> >> >> being the largest adopter of unprivileged user namespaces for g=
eneral
> >> >> purpose containers.
> >> >>=20
> >> >> I expect you just call newuidmap and newgidmap and don't actual=
ly care
> >> >> about not being able to set gid_map without privilege.  But I r=
eally
> >> >> want to avoid pushing a security fix and then being surprised t=
hat
> >> >> things like lxc break.
> >> >>=20
> >> >> Eric
> >> >
> >> > Hi Eric,
> >> >
> >> > I've unfortunately been pretty busy this week as I was (well, st=
ill am)
> >> > travelling to South Africa for a meeting. I don't have a full ke=
rnel
> >> > tree around here and a full git clone isn't really doable over t=
he kind
> >> > of Internet I've got here :)
> >> >
> >> > Hopefully Serge can give it a quick try, otherwise I should be a=
ble to
> >> > do some tests on Tuesday when I'm back home.
> >>=20
> >> I thought Serge was going to but I haven't heard yet so I am prodd=
ing ;-)
> >
> > Ok, thanks - yes, unprivileged lxc is working fine with your kernel=
s.
> > Just to be sure I was testing the right thing I also tested using
> > my unprivileged nsexec testcases, and they failed on setgroup/setgi=
d
> > as now expected, and succeeded there without your patches.
>=20
> Thanks.
>=20
> Serge unless you object will add your Tested-By to my pull message to=
 Linus.

Sounds good.

> Minor question do you runprivileged nsexec test cases test to see if =
the
> write to gid_map succeeds?  I would have expected the gid_map write t=
o
> fail before the setgroups setgid system calls came into play.

Yes, I did that by hand, and it failed (with your kernel).

-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
