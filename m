From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: Re: [PATCH 26/34] mm: implement new mprotect_key() system call
Date: Wed, 9 Dec 2015 09:05:06 -0800
Message-ID: <56685F42.8070109@sr71.net>
References: <20151204011424.8A36E365@viggo.jf.intel.com>
 <20151204011500.69487A6C@viggo.jf.intel.com> <5662894B.7090903@gmail.com>
 <5665B767.8020802@sr71.net> <56680BA6.20406@gmail.com>
 <56684D3B.5050805@sr71.net>
 <CAKgNAkiZHny4amNcamN+q6pxdanG9aMMA4H_pekA7+RDuoUvEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkiZHny4amNcamN+q6pxdanG9aMMA4H_pekA7+RDuoUvEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/09/2015 08:45 AM, Michael Kerrisk (man-pages) wrote:
>>> >> * Explanation of what a protection domain is.
>> >
>> > A protection domain is a unique view of memory and is represented by the
>> > value in the PKRU register.
> Out something about this in pkey(7), but explain what you mean by a
> "unique view of memory".

Let's say there are only two protection keys: 0 and 1.  There are two
disable bits per protection key (Access and Write Disable), so a two-key
PKRU looks like:

|   PKEY0   |   PKEY1   |
| AD0 | WD0 | AD1 | WD1 |

In this example, there are 16 possible protection domains, one for each
possible combination of the 4 rights-disable bits.

"Changing a protection domain" would mean changing (setting or clearing)
the value of any of those 4 bits.  Each unique value of PKRU represents
a view of memory, or unique protection domain.
