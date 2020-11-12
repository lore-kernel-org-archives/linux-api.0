Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC7FC388F7
	for <linux-api@archiver.kernel.org>; Thu, 12 Nov 2020 20:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D1902076E
	for <linux-api@archiver.kernel.org>; Thu, 12 Nov 2020 20:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgKLUBe (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 12 Nov 2020 15:01:34 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45134 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgKLUBe (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 12 Nov 2020 15:01:34 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kdImb-005IBG-TX; Thu, 12 Nov 2020 13:01:25 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kdIma-000utT-PB; Thu, 12 Nov 2020 13:01:25 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Richard Henderson <rth@twiddle.net>, linux-api@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
        David Spickett <david.spickett@linaro.org>
References: <cover.1604523707.git.pcc@google.com>
        <0eb601a5d1906fadd7099149eb605181911cfc04.1604523707.git.pcc@google.com>
        <87zh3qug6q.fsf@x220.int.ebiederm.org> <20201111172703.GP6882@arm.com>
        <87imabr6p8.fsf@x220.int.ebiederm.org> <20201112172345.GU6882@arm.com>
Date:   Thu, 12 Nov 2020 14:01:12 -0600
In-Reply-To: <20201112172345.GU6882@arm.com> (Dave Martin's message of "Thu,
        12 Nov 2020 17:23:45 +0000")
Message-ID: <87mtzmny47.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kdIma-000utT-PB;;;mid=<87mtzmny47.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ffs7Ll6mCDO23I2NWN7+/b2Ktf5M01G8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v14 7/8] signal: define the field siginfo.si_faultflags
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Dave Martin <Dave.Martin@arm.com> writes:

> On Wed, Nov 11, 2020 at 02:15:15PM -0600, Eric W. Biederman wrote:
>> Dave Martin <Dave.Martin@arm.com> writes:
>> 
>> > On Mon, Nov 09, 2020 at 07:57:33PM -0600, Eric W. Biederman wrote:
>> >> Peter Collingbourne <pcc@google.com> writes:
>> >> 
>> >> > This field will contain flags that may be used by signal handlers to
>> >> > determine whether other fields in the _sigfault portion of siginfo are
>> >> > valid. An example use case is the following patch, which introduces
>> >> > the si_addr_tag_bits{,_mask} fields.
>> >> >
>> >> > A new sigcontext flag, SA_FAULTFLAGS, is introduced in order to allow
>> >> > a signal handler to require the kernel to set the field (but note
>> >> > that the field will be set anyway if the kernel supports the flag,
>> >> > regardless of its value). In combination with the previous patches,
>> >> > this allows a userspace program to determine whether the kernel will
>> >> > set the field.
>> >> >
>> >> > It is possible for an si_faultflags-unaware program to cause a signal
>> >> > handler in an si_faultflags-aware program to be called with a provided
>> >> > siginfo data structure by using one of the following syscalls:
>> >> >
>> >> > - ptrace(PTRACE_SETSIGINFO)
>> >> > - pidfd_send_signal
>> >> > - rt_sigqueueinfo
>> >> > - rt_tgsigqueueinfo
>> >> >
>> >> > So we need to prevent the si_faultflags-unaware program from causing an
>> >> > uninitialized read of si_faultflags in the si_faultflags-aware program when
>> >> > it uses one of these syscalls.
>> >> >
>> >> > The last three cases can be handled by observing that each of these
>> >> > syscalls fails if si_code >= 0. We also observe that kill(2) and
>> >> > tgkill(2) may be used to send a signal where si_code == 0 (SI_USER),
>> >> > so we define si_faultflags to only be valid if si_code > 0.
>> >> >
>> >> > There is no such check on si_code in ptrace(PTRACE_SETSIGINFO), so
>> >> > we make ptrace(PTRACE_SETSIGINFO) clear the si_faultflags field if it
>> >> > detects that the signal would use the _sigfault layout, and introduce
>> >> > a new ptrace request type, PTRACE_SETSIGINFO2, that a si_faultflags-aware
>> >> > program may use to opt out of this behavior.
>> >> 
>> >> So I think while well intentioned this is misguided.
>> >> 
>> >> gdb and the like may use this but I expect the primary user is CRIU
>> >> which simply reads the signal out of one process saves it on disk
>> >> and then restores the signal as read into the new process (possibly
>> >> on a different machine).
>> >> 
>> >> At least for the CRIU usage PTRACE_SETSIGINFO need to remain a raw
>> >> pass through kind of operation.
>> >
>> > This is a problem, though.
>> >
>> > How can we tell the difference between a siginfo that was generated by
>> > the kernel and a siginfo that was generated (or altered) by a non-xflags
>> > aware userspace?
>> >
>> > Short of revving the whole API, I don't see a simple solution to this.
>> 
>> Unlike receiving a signal.  We do know that userspace old and new
>> always sends unused fields as zero into PTRACE_SETSIGINFO.
>> 
>> The split into kernel_siginfo verifies this and fails userspace if it
>> does something different.  No problems have been reported.
>> 
>> So in the case of xflags a non-xflags aware userspace would either pass
>> the siginfo from through from somewhere else (such as
>> PTRACE_GETSIGINFO), or it would simply generate a signal with all of
>> the xflags bits clear.  So everything should work regardless.
>> 
>> > Although a bit of a hack, could we include some kind of checksum in the
>> > siginfo?  If the checksum matches during PTRACE_SETSIGINFO, we could
>> > accept the whole thing; xflags included.  Otherwise, we could silently
>> > drop non-self-describing extensions.
>> >
>> > If we only need to generate the checksum when PTRACE_GETSIGINFO is
>> > called then it might be feasible to use a strong hash; otherwise, this
>> > mechanism will be far from bulletproof.
>> >
>> > A hash has the advantage that we don't need any other information
>> > to validate it beyond a salt: if the hash matches, it's self-
>> > validating.  We could also package other data with it to describe the
>> > presence of extensions, but relying on this for regular sigaction()/
>> > signal delivery use feels too high-overhead.
>> >
>> > For debuggers, I suspect that PTRACE_SETSIGINFO2 is still useful:
>> > userspace callers that want to write an extension field that they
>> > knowingly generated themselves should have a way to express that.
>> >
>> > Thoughts?
>
> Eric, did you have any view on the hash idea here?

I am not quite certain what you meant by salt.  A per kernel instance
secret I suspect.

Such a secret would break creating siginfo by hand and checkpointing
and restoring on a different machine.

If you don't go with full crypto security it sounds like it would work.

If we really need to deploy xflags I think it bears looking at, but
right now it feels like one thing too many.



Eric

