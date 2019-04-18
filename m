From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 2/5] clone: add CLONE_PIDFD
Date: Thu, 18 Apr 2019 16:15:07 +0200
Message-ID: <A186BAC7-898A-4860-921D-1E2B638E8D52@brauner.io>
References: <20190418101841.4476-1-christian@brauner.io> <20190418101841.4476-3-christian@brauner.io> <20190418131206.GB13701@redhat.com> <20190418132822.untjt7erfvbbiz7a@brauner.io> <20190418141019.GD13701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418141019.GD13701@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On April 18, 2019 4:10:20 PM GMT+02:00, Oleg Nesterov <oleg@redhat=2Ecom> w=
rote:
>On 04/18, Christian Brauner wrote:
>>
>> On Thu, Apr 18, 2019 at 03:12:07PM +0200, Oleg Nesterov wrote:
>> > Should we allow CLONE_THREAD | CLONE_PIDFD ?
>>
>> I think so, yes=2E I have thought about this=2E
>
>OK, I won't insist=2E But let me explain why did I ask=2E
>
>> Yes, due to CLONE_FILES |
>> CLONE_VM you'd necessarily hand the pidfd to the child but threads
>are
>> no security boundary in the first place=2E
>
>No, no, I am not not worried about security=2E CLONE_PARENT | CLONE_PIDFD
>looks more problematic to me, but I see nothing dangerous
>security-wise=2E=2E
>
>I agree that CLONE_THREAD | CLONE_PIDFD may be usefule, but I am not
>sure
>we should allow this from the very begining, until we have a "real"
>use-case=2E
>
>IIUC, we are going to make it pollable soon=2E OK, but
>proc_tgid_base_poll()
>(which should be turned into pidfd_poll) simply can't work if
>pid_task() is
>not a group leader=2E poll(pidfd) will hang forever if pidfd was created
>by
>CLONE_THREAD | CLONE_PIDFD=2E
>
>Sure, we can (should?) improve pidfd_poll() but this will need more
>nasty
>changes in the core kernel code=2E Do we really need/want this? Right now
>it
>is not clear to me=2E Instead, we can simply disallow
>CLONE_THREAD|CLONE_PIDFD
>until we decide that yes, we want to poll sub-threads=2E

If you think that makes the polling work simpler for Joel then for sure=2E
And yes, I have argued for "disable until someone needs it" often before s=
o I can't really argue the other way around here=2E :)
I'll send an updated version soon=2E

Christian

>
>But again, I am fine with CLONE_THREAD | CLONE_PIDFD=2E
>
>Oleg=2E
