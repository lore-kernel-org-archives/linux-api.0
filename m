From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 8/8] signal: Remove kernel interal si_code magic
Date: Wed, 12 Jul 2017 18:08:07 -0500
Message-ID: <87wp7dgso8.fsf@xmission.com>
References: <87efu22set.fsf@xmission.com>
        <20170630123906.8865-8-ebiederm@xmission.com>
        <20170712223557.GA21885@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170712223557.GA21885@outlook.office365.com> (Andrei Vagin's
        message of "Wed, 12 Jul 2017 15:36:04 -0700")
Sender: linux-arch-owner@vger.kernel.org
To: Andrei Vagin <avagin@virtuozzo.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Andrei Vagin <avagin@virtuozzo.com> writes:

>> diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
>> index 54804866f238..4433d1dc28e6 100644
>> --- a/arch/tile/kernel/traps.c
>> +++ b/arch/tile/kernel/traps.c
>> @@ -188,7 +188,6 @@ static int special_ill(tile_bundle_bits bundle, int *sigp, int *codep)
>>  
>>  	/* Make it the requested signal. */
>>  	*sigp = sig;
>> -	*codep = code | __SI_FAULT;
>
> Are you sure that we don't need to set codep here?

Looking closely we definitely do.  Good catch.  Thank you.

Eric
