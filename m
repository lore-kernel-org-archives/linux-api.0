From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC v3 8/9] kmsg: add predefined _PID, _TID,
 _COMM keywords to kmsg* log dict
Date: Tue, 20 Oct 2015 13:16:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1510201313220.13957@AMDC1262.digital.local>
References: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
 <1445259503-18158-9-git-send-email-p.osmialowsk@samsung.com>
 <CALCETrW2CgnS5pwS278ipLOSQi95UOT-osoSpshGwFmBf7TgRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <CALCETrW2CgnS5pwS278ipLOSQi95UOT-osoSpshGwFmBf7TgRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On Mon, 19 Oct 2015, Andy Lutomirski wrote:

> On Mon, Oct 19, 2015 at 5:58 AM, Paul Osmialowski
> <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
>> From: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>
>> kmsg* devices write operation wrote no dict along with message
>> Due to usage of kmsg devices in userspace dict has been added
>> identifying pid, tid and comm of writing process.
>
> Does this affect even the normal /dev/kmsg?

Yes.

>
>> -static int kmsg_sys_write(int minor, int level, const char *fmt, ...)
>> +static size_t set_kmsg_dict(char *buf)
>> +{
>> +       size_t len;
>> +
>> +       len = sprintf(buf, "_PID=%d", task_tgid_nr(current)) + 1;
>> +       len += sprintf(buf + len, "_TID=%d", task_pid_nr(current)) + 1;
>> +       memcpy(buf + len, "_COMM=", 6);
>> +       len += 6;
>> +       get_task_comm(buf + len, current);
>> +       while (buf[len] != '\0')
>> +               len++;
>
> len += strlen(buf); ?
>
> Is it obvious for some reason that this doesn't overflow buf?
>

KMSG_DICT_MAX_LEN sets architecture-intepentent max size.

> Why is task_pid_nr acceptable here?  Isn't this intended for use in namespaces?
>

task_tgid_nr - process id (pid as seen in userspace),
task_pid_nr - thread id

Thanks,
Paul
