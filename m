From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
Date: Mon, 01 Dec 2014 07:47:26 +0100
Message-ID: <87egsjrhmp.fsf@mid.deneb.enyo.de>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
	<87k32d13d5.fsf@mid.deneb.enyo.de>
	<CALCETrV_aArOr7v4AqLHdyGGNU-5XBPmvBXEqbVU36EJ_G26uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrV_aArOr7v4AqLHdyGGNU-5XBPmvBXEqbVU36EJ_G26uQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Sun, 30 Nov 2014 14:08:13 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, systemd Mailing List <systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* Andy Lutomirski:

> On Nov 30, 2014 1:47 AM, "Florian Weimer" <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org> wrote:
>>
>> * Andy Lutomirski:
>>
>> > The initial implementation is straightforward: highpid is simply a
>> > 64-bit counter. If a high-end system can fork every 3 ns (which
>> > would be amazing, given that just allocating a pid requires at
>> > atomic operation), it would take well over 1000 years for highpid to
>> > wrap.
>>
>> I'm not sure if I'm reading the patch correctly, but is the counter
>> namespaced?  If yes, why?
>
> It's namespaced so that CRIU can migrate/restore a whole pid namespace.

Oh well, this requirement is at odds with system-wide uniqueness.  Is
CRIU really that important? :-)
