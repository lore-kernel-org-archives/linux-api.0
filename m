From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 7 Jan 2015 18:35:53 -0500
Message-ID: <20150107233553.GC28630@htj.dyndns.org>
References: <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
	<54ACFC38.5070007@nod.at> <87fvbmir9q.fsf@x220.int.ebiederm.org>
	<20150107193059.GA1857@mail.hallyn.com>
	<87bnma6xwv.fsf@x220.int.ebiederm.org>
	<20150107224430.GA28414@htj.dyndns.org>
	<878uhe42km.fsf@x220.int.ebiederm.org>
	<20150107230615.GA28630@htj.dyndns.org>
	<87fvbm2nni.fsf@x220.int.ebiederm.org>
	<87y4peyxw5.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87y4peyxw5.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 07, 2015 at 05:27:38PM -0600, Eric W. Biederman wrote:
> >> The -o SUBSYS option doesn't exist.  Jesus, at least get yourself
> >> familiar with the basics before claiming random stuff.
> 
> Oh let's see I got that command line option out of /proc/mounts and yes
> it works.  Perhaps it doesn't if I invoke unified hiearchies but the
> option does in fact exist and work.

I meant the -o SUBSYS doesn't exist for unified hierarchy.

> Now I really do need to test report regressions, and send probably send
> regression fixes.  If I understand your strange ranting I think you just
> told me that option that -o SUBSYS does work with unified hierarchies.

What?  Why would -O SUBSYS exist for unified hierarchy?  It's unified
for all controllers.

> Tejun.  I asked you specifically about this case 2 years ago at plumbers
> and you personally told me this would continue to work.  I am going to
> hold you to that.

I have no idea what you're talking about in *THIS* thread.  I'm fully
aware of what was discussed *THEN*.

> Fixing bugs is one thing.  Gratuitious regressions that make supporting
> existing user space applications insane is another.

Can you explain what problem you're actually trying to talk about
without spouting random claims about regressions?

-- 
tejun
