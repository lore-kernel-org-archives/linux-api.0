From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
Date: Tue, 17 Jun 2014 09:41:22 -0700
Message-ID: <CALCETrVerC155vzO-1Js1W8cRTYat0-+OGOxW+kSynJor6rJag@mail.gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
 <CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com>
 <CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>
 <CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>
 <CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>
 <53A01049.6020502@redhat.com> <CANq1E4T3KJZ++=KF2OZ_dd+NvPqg+=4Pw6O7Po3-ZxaaMHPukw@mail.gmail.com>
 <CALCETrVpZ0vFM4usHK+tQhk234Y2jWzB1522kGcGvdQQFAqsZQ@mail.gmail.com> <CANq1E4QdGz6cRm2Y-vMQHV1O=VK74XNP8qCAmiAskVaVKpJuxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CANq1E4QdGz6cRm2Y-vMQHV1O=VK74XNP8qCAmiAskVaVKpJuxg@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Greg KH <greg@kroah.com>, Florian Weimer <fweimer@redhat.com>, Hugh Dickins <hughd@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lennart Poettering <lennart@poettering.net>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Kay Sievers <kay@vrfy.org>, John Stultz <john.stultz@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Mack <zonque@gmail.com>, Ryan Lortie <desrt@desrt.ca>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tony Battersby <tonyb@cybernetics.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 17, 2014 at 9:36 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Tue, Jun 17, 2014 at 6:20 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Can you summarize why holes can't be reliably backed by the zero page?
>
> To answer this, I will quote Hugh from "PATCH v2 1/3":
>
>> We do already use the ZERO_PAGE instead of allocating when it's a
>> simple read; and on the face of it, we could extend that to mmap
>> once the file is sealed.  But I am rather afraid to do so - for
>> many years there was an mmap /dev/zero case which did that, but
>> it was an easily forgotten case which caught us out at least
>> once, so I'm reluctant to reintroduce it now for sealing.
>>
>> Anyway, I don't expect you to resolve the issue of sealed holes:
>> that's very much my territory, to give you support on.
>
> Holes can be avoided with a simple fallocate(). I don't understand why
> I should make SEAL_WRITE do the fallocate for the caller. During the
> discussion of memfd_create() I was told to drop the "size" parameter,
> because it is redundant. I don't see how this implicit fallocate()
> does not fall into the same category?
>

I'm really confused now.

If I SEAL_WRITE a file, and then I mmap it PROT_READ, and then I read
it, is that a "simple read"?  If so, doesn't that mean that there's no
problem?

--Andy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
