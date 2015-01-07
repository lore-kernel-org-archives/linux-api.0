From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 07 Jan 2015 17:27:38 -0600
Message-ID: <87y4peyxw5.fsf@x220.int.ebiederm.org>
References: <87lhlgpyxk.fsf@x220.int.ebiederm.org>
	<CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
	<54AB2992.6060707@nod.at>
	<CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
	<54ACFC38.5070007@nod.at> <87fvbmir9q.fsf@x220.int.ebiederm.org>
	<20150107193059.GA1857@mail.hallyn.com>
	<87bnma6xwv.fsf@x220.int.ebiederm.org>
	<20150107224430.GA28414@htj.dyndns.org>
	<878uhe42km.fsf@x220.int.ebiederm.org>
	<20150107230615.GA28630@htj.dyndns.org>
	<87fvbm2nni.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87fvbm2nni.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Wed, 07 Jan 2015 17:09:53 -0600")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:

> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
>
>> On Wed, Jan 07, 2015 at 05:02:17PM -0600, Eric W. Biederman wrote:
>>> Ignoring namespace details for a moment. The following should be
>>> possible with a unified hierarchy.  If it is not it is a show stopper
>>> of a regression.
>>
>> The -o SUBSYS option doesn't exist.  Jesus, at least get yourself
>> familiar with the basics before claiming random stuff.

Oh let's see I got that command line option out of /proc/mounts and yes
it works.  Perhaps it doesn't if I invoke unified hiearchies but the
option does in fact exist and work.

Now I really do need to test report regressions, and send probably send
regression fixes.  If I understand your strange ranting I think you just
told me that option that -o SUBSYS does work with unified hierarchies.

Tejun.  I asked you specifically about this case 2 years ago at plumbers
and you personally told me this would continue to work.  I am going to
hold you to that.

Fixing bugs is one thing.  Gratuitious regressions that make supporting
existing user space applications insane is another.

Eric
