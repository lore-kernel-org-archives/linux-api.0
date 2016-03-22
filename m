From: Jessica Yu <jeyu@redhat.com>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Tue, 22 Mar 2016 15:00:19 -0400
Message-ID: <20160322190018.GB30747@packer-debian-8-amd64.digitalocean.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-5-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1603211449240.12175@pobox.suse.cz>
 <20160321191832.GC12357@packer-debian-8-amd64.digitalocean.com>
 <alpine.LNX.2.00.1603212213340.3656@cbobk.fhfr.pm>
 <20160321213445.e64jic2uoc7tdtbl@treble.redhat.com>
 <alpine.LNX.2.00.1603212256080.3656@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1603212256080.3656@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>, Petr Mladek <pmladek@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Jiri Kosina [21/03/16 23:02 +0100]:
>On Mon, 21 Mar 2016, Josh Poimboeuf wrote:
>
>> According to my test that still results in the literal value of
>> "(64 - 8)".
>
>Alright. But we should be able to special-case it with a two #if checks on
>the __SIZEOF_LONG__ value and BUILD_BUG_ON() when __SIZEOF_LONG__ is not
>of one of the ususal sizes.
>

And while we're at it, we might as well add a BUILD_BUG_ON check for
KSYM_NAME_LEN too, since we are also hard coding that field width, and
we'd like to be alerted if that value ever changes.
