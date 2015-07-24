From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v4 3/5] pagemap: rework hugetlb and thp report
Date: Fri, 24 Jul 2015 19:17:49 +0100
Message-ID: <CAEVpBaKTMs7JQrwHQVKF5ySb58QTm6Zr+GPgZevtjgStYBk8RQ@mail.gmail.com>
References: <20150714152516.29844.69929.stgit@buzz>
	<20150714153738.29844.39039.stgit@buzz>
	<20150721080046.GC2475@hori1.linux.bs1.fc.nec.co.jp>
	<CALYGNiO9wpmnrqbKhRKvfHgnUC854accifKc3m6Bvqsv0LHqXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALYGNiO9wpmnrqbKhRKvfHgnUC854accifKc3m6Bvqsv0LHqXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Reviewed-by: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>

On Tue, Jul 21, 2015 at 9:43 AM, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Jul 21, 2015 at 11:00 AM, Naoya Horiguchi
> <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org> wrote:
>> On Tue, Jul 14, 2015 at 06:37:39PM +0300, Konstantin Khlebnikov wrote:
>>> This patch moves pmd dissection out of reporting loop: huge pages
>>> are reported as bunch of normal pages with contiguous PFNs.
>>>
>>> Add missing "FILE" bit in hugetlb vmas.
>>>
>>> Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
>>
>> With reflecting Kirill's comment about #ifdef, I'm OK for this patch.
>
> That ifdef works most like documentation: "all thp magic happens here".
> I'd like to keep it, if two redundant lines isn't a big deal.
>
>>
>> Reviewed-by: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a hrefmailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
