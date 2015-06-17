From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] pagemap: switch to the new format and do some cleanup
Date: Wed, 17 Jun 2015 07:59:33 +0300
Message-ID: <CALYGNiNrEPffQwhjhqB6jor5b8w6BQ=KnAa3LrxQ6QFKERH_mQ@mail.gmail.com>
References: <20150609200021.21971.13598.stgit@zurg>
	<20150615055649.4485.92087.stgit@zurg>
	<20150616142935.b8f679650e35534e75806399@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150616142935.b8f679650e35534e75806399-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 17, 2015 at 12:29 AM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Mon, 15 Jun 2015 08:56:49 +0300 Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> This patch removes page-shift bits (scheduled to remove since 3.11) and
>> completes migration to the new bit layout. Also it cleans messy macro.
>
> hm, I can't find any kernel version to which this patch comes close to
> applying.

This patchset applies to  4.1-rc8 and current mmotm without problems.
I guess you've tried pick this patch alone without previous changes.
