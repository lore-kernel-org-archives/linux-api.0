From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v4 0/2] Add further ioctl() operations for namespace discovery
Date: Thu, 26 Jan 2017 17:23:46 +1300
Message-ID: <87a8aea1pp.fsf@xmission.com>
References: <93e5c7f9-9dc1-6c93-ad20-0ba053d8bfef@gmail.com>
        <963f76f9-3ae5-b316-e688-00d3e59cad30@gmail.com>
        <87d1fblx2s.fsf@xmission.com>
        <CAKgNAki0y7TbZbTPt-E6tjPX2BASaFfT+KcX_tywb2ASADiw9g@mail.gmail.com>
        <877f5jlvs1.fsf@xmission.com> <87tw8nkh4k.fsf@xmission.com>
        <CAKgNAkjZTUSbdX0m69+TBOTM3jz_O8byH4W0SrY3wUD5gyUk1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkjZTUSbdX0m69+TBOTM3jz_O8byH4W0SrY3wUD5gyUk1A@mail.gmail.com>
        (Michael Kerrisk's message of "Wed, 25 Jan 2017 16:50:22 +1300")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:


> On 25 January 2017 at 15:28, Eric W. Biederman <ebiederm@xmission.com> wrote:

>> My concern is that the difference between returning -EOVERFLOW and
>> overflow_uid is primarily about usability.  If you haven't played with
>> the usability I don't trust that we have made the proper trade off.
>
> So, I had not initially included the no-UID-mapping case, and when you
> proposed -EOVERFLOW for that case, it seemed better.
>
> On reflection, mapping to the overflow_uid seems simpler. Taking the
> example shown in my other mail a short time ago, the unmapped UID 0
> from the outer namespace would map to the overflow_uid (which UID my
> program would print), but my program would still correctly report that
> the UID 0 process in the outer namespace might (subject to LSM checks)
> have capabilities in the inner namespace.
>
> So, it seems that reverting the EOVERFLOW change is in order (and my
> example program thus needs no changes). Does that sound reasonable to
> you?

It does.  I just care that you have thought through the tradeoffs of
that corner of the interface design.

Eric
