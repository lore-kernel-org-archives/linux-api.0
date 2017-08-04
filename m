From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Thu, 3 Aug 2017 21:15:27 -0400
Message-ID: <20170804011527.l4p2ud6scnaklhhh@thunk.org>
References: <c782a15a-4e73-7373-ca66-5b55e9406059@roeck-us.net>
 <20170705130200.7c653f61@gandalf.local.home>
 <87zibkzgve.fsf@xmission.com>
 <fb399eba-91eb-21a5-e3f5-c3f919061c12@osg.samsung.com>
 <87lgn1nac8.fsf@xmission.com>
 <61093c3f-6ad0-c033-a524-f2624f8d55ba@osg.samsung.com>
 <87r2wtluc1.fsf@xmission.com>
 <92c31d6f-f98d-c764-eeec-bd0a2316d769@osg.samsung.com>
 <20170803030327.gf7pl7foer3abdpe@thunk.org>
 <a313d401-d18b-ed9a-d82d-f6e12f606743@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a313d401-d18b-ed9a-d82d-f6e12f606743-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 03, 2017 at 12:51:07PM -0600, Shuah Khan wrote:
> 
> It wasn't my intent to be hostile.

Sorry I wasn't clear; I wasn't saying you were being hostile.  It's
just that I am simultaneously trying to test multiple kernel
cofigurations against a common source tree, and the reason why I use
separate build directories is the alternative is each time I change
configurations, around 2 GB of object files get rewritten.  So a
feature which requires that I give up a workflow such that I would be
I constantly rebuild (and rewrite) gigabytes of object files is
hostile to be my development workflow --- and so unless I hear
testimonials about how it's amazingly useful, I'm highly unlikely to
even experiment with it.

Nothing personal.... it just doesn't fit with my development practices.

Cheers,

					- Ted
