From: Daniel Colascione <dancol@google.com>
Subject: Re: [REGRESSION] "Locked" and "Pss" in /proc/*/smaps are the same
Date: Tue, 3 Jul 2018 09:20:02 -0700
Message-ID: <CAKOZuev9K0EMpqBoie4H7XduB63KayORxO=JEZvS9rv_4PVsqQ@mail.gmail.com>
References: <69eb77f7-c8cc-fdee-b44f-ad7e522b8467@gmail.com> <ebf6c7fb-fec3-6a26-544f-710ed193c154@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ebf6c7fb-fec3-6a26-544f-710ed193c154@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Lindroth <thomas.lindroth@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 3, 2018 at 12:36 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> +CC
>
> On 07/01/2018 08:31 PM, Thomas Lindroth wrote:
>> While looking around in /proc on my v4.14.52 system I noticed that
>> all processes got a lot of "Locked" memory in /proc/*/smaps. A lot
>> more memory than a regular user can usually lock with mlock().
>>
>> commit 493b0e9d945fa9dfe96be93ae41b4ca4b6fdb317 (v4.14-rc1) seems
>> to have changed the behavior of "Locked".

Thanks for fixing that. I submitted a patch [1] for this bug and some
others a while ago, but the patch didn't make it into the tree because
or wasn't split up correctly or something, and I had to do other work.

[1] https://marc.info/?l=linux-mm&m=151927723128134&w=2
