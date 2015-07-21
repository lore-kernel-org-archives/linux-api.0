From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] console_codes.4: Add CSI sequence for cursor blink interval
Date: Tue, 21 Jul 2015 18:55:11 +0200
Message-ID: <CAKgNAkgqTckfydFTDFsoqB1b_fAEiDZGYP=7b-bhN8d4Mp-bsg@mail.gmail.com>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
 <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
 <20150225094946.GA24627@amd> <alpine.LNX.2.11.1502252319330.276@localhost>
 <20150226220243.GC9935@amd> <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost> <20150325111949.GA24230@kroah.com>
 <alpine.DEB.2.11.1503261341260.2164@local> <alpine.DEB.2.11.1503261356490.2411@local>
 <alpine.DEB.2.11.1507051724240.1696@local>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507051724240.1696@local>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Scot,

On 5 July 2015 at 19:41, Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org> wrote:
> On Thu, 26 Mar 2015, Scot Doyle wrote:
>> Add a Console Private CSI sequence to specify the current console's
>> cursor blink interval. The interval is specified as a number of
>> milliseconds until the next cursor display state toggle, from 50 to
>> 65535.
>>
>> Signed-off-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>

I've applied this, adding Pavel's Acked-by.

I also added some text to note that this appeared in Linux 4.2. Okay?

Cheers,

Michael


>> ---
>>  man4/console_codes.4 | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/man4/console_codes.4 b/man4/console_codes.4
>> index 34f7535..7d05076 100644
>> --- a/man4/console_codes.4
>> +++ b/man4/console_codes.4
>> @@ -377,6 +377,7 @@ ESC [ 15 ]        T{
>>  Bring the previous console to the front
>>  (since Linux 2.6.0).
>>  T}
>> +ESC [ 16 ; \fIn\fP ]         Set the cursor blink interval in milliseconds.
>>  .TE
>>  .SS Character sets
>>  The kernel knows about 4 translations of bytes into console-screen
>> --
>> 2.1.0
>>
>
> Hi Michael,
>
> Will you apply now that Linus has pulled the rest?
> (see bd63364caa8df38bad2b25b11b2a1b849475cce5)
>
> Thank you,
> Scot



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
