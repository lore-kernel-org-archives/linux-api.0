From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH]Fix: 32bit binary has 64bit address of stack vma
Date: Fri, 9 Jan 2009 17:32:54 -0800
Message-ID: <604427e00901091732reaef7b5u6ccd89ffb840dbb8@mail.gmail.com>
References: <604427e00901051539x52ab85bcua94cd8036e5b619a@mail.gmail.com>
	 <604427e00901081840pa6dcc41u9a7a5c69302c7b60@mail.gmail.com>
	 <604427e00901091627n7c909abt6aa1f01c181ad65d@mail.gmail.com>
	 <20090109163725.11294fb1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090109163725.11294fb1.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 9, 2009 at 4:37 PM, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Fri, 9 Jan 2009 16:27:07 -0800
> Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
>> friendly ping...
>
> We'll get there.  We're in the merge window now, so I tend to defer
> non-serious bugfixes until things are a bit quieter.
Thank you Andrew .

>
>> On Thu, Jan 8, 2009 at 6:40 PM, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Mon, Jan 5, 2009 at 3:39 PM, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> >> From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> >>
>> >> Fix 32bit binary get 64bit stack vma offset.
>> >>
>> >> 32bit binary running on 64bit system, the /proc/pid/maps shows for the
>> >> vma represents stack get a 64bit adress:
>> >> ff96c000-ff981000 rwxp 7ffffffea000 00:00 0 [stack]
>
> That changelog hurts my brain.
hm, i will change it for better reading.
>
>> >> Signed-off-by:  Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
