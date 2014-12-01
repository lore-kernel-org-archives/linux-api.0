From: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
Date: Mon, 1 Dec 2014 15:33:38 +0300
Message-ID: <547C6022.1030904@parallels.com>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>	<87k32d13d5.fsf@mid.deneb.enyo.de>	<CALCETrV_aArOr7v4AqLHdyGGNU-5XBPmvBXEqbVU36EJ_G26uQ@mail.gmail.com> <87egsjrhmp.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87egsjrhmp.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>, Andy Lutomirski <luto@amacapital.net>
Cc: criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, David Herrmann <dh.herrmann@gmail.com>, systemd Mailing List <systemd-devel@lists.freedesktop.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 12/01/2014 09:47 AM, Florian Weimer wrote:
> * Andy Lutomirski:
> 
>> On Nov 30, 2014 1:47 AM, "Florian Weimer" <fw@deneb.enyo.de> wrote:
>>>
>>> * Andy Lutomirski:
>>>
>>>> The initial implementation is straightforward: highpid is simply a
>>>> 64-bit counter. If a high-end system can fork every 3 ns (which
>>>> would be amazing, given that just allocating a pid requires at
>>>> atomic operation), it would take well over 1000 years for highpid to
>>>> wrap.
>>>
>>> I'm not sure if I'm reading the patch correctly, but is the counter
>>> namespaced?  If yes, why?
>>
>> It's namespaced so that CRIU can migrate/restore a whole pid namespace.
> 
> Oh well, this requirement is at odds with system-wide uniqueness.  Is
> CRIU really that important? :-)

Well, in this context it is. Since the main (if not the only) use-case for
highpid is to read one, remember, then compare to new value, restoring it
to wrong/arbitrary value will break the using applications in 100% cases.

Thus we really need the ability to restore this value.

Thanks,
Pavel
