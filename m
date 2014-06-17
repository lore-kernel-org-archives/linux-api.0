From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
Date: Tue, 17 Jun 2014 12:04:56 +0200
Message-ID: <53A012C8.7060109@redhat.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>	<CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com>	<CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>	<CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>	<CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>	<53A01049.6020502@redhat.com> <CANq1E4T3KJZ++=KF2OZ_dd+NvPqg+=4Pw6O7Po3-ZxaaMHPukw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CANq1E4T3KJZ++=KF2OZ_dd+NvPqg+=4Pw6O7Po3-ZxaaMHPukw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <greg@kroah.com>, John Stultz <john.stultz@linaro.org>, Lennart Poettering <lennart@poettering.net>, Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>, Hugh Dickins <hughd@google.com>, Tony Battersby <tonyb@cybernetics.com>
List-Id: linux-api@vger.kernel.org

On 06/17/2014 12:01 PM, David Herrmann wrote:

>> I don't think this is what potential users expect because mlock requires
>> capabilities which are not available to them.
>>
>> A couple of weeks ago, sealing was to be applied to anonymous shared memory.
>> Has this changed?  Why should *reading* it trigger OOM?
>
> The file might have holes, therefore, you'd have to allocate backing
> pages. This might hit a soft-limit and fail. To avoid this, use
> fallocate() to allocate pages prior to mmap()

This does not work because the consuming side does not know how the 
descriptor was set up if sealing does not imply that.

> or mlock() to make the kernel lock them in memory.

See above for why that does not work.

I think you should eliminate the holes on sealing and report ENOMEM 
there if necessary.

-- 
Florian Weimer / Red Hat Product Security Team

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
