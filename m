From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC v3 8/9] kmsg: add predefined _PID, _TID, _COMM keywords to
 kmsg* log dict
Date: Tue, 20 Oct 2015 11:19:46 -0700
Message-ID: <CALCETrWmx+T0pUyKpt5W9mr3ewFb2tR8k8_i9VzpD8JURkOeNA@mail.gmail.com>
References: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
 <1445259503-18158-9-git-send-email-p.osmialowsk@samsung.com>
 <CALCETrW2CgnS5pwS278ipLOSQi95UOT-osoSpshGwFmBf7TgRQ@mail.gmail.com> <alpine.DEB.2.10.1510201313220.13957@AMDC1262.digital.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1510201313220.13957@AMDC1262.digital.local>
Sender: linux-doc-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 4:16 AM, Paul Osmialowski
<p.osmialowsk@samsung.com> wrote:
> Hi Andy,
>
> On Mon, 19 Oct 2015, Andy Lutomirski wrote:
>
>> On Mon, Oct 19, 2015 at 5:58 AM, Paul Osmialowski
>> <p.osmialowsk@samsung.com> wrote:
>>>
>>> From: Marcin Niesluchowski <m.niesluchow@samsung.com>
>>>
>>> kmsg* devices write operation wrote no dict along with message
>>> Due to usage of kmsg devices in userspace dict has been added
>>> identifying pid, tid and comm of writing process.
>>
>>
>> Does this affect even the normal /dev/kmsg?
>
>
> Yes.

Is this okay?  Comm at least is a bit odd.

>
>>
>>> -static int kmsg_sys_write(int minor, int level, const char *fmt, ...)
>>> +static size_t set_kmsg_dict(char *buf)
>>> +{
>>> +       size_t len;
>>> +
>>> +       len = sprintf(buf, "_PID=%d", task_tgid_nr(current)) + 1;
>>> +       len += sprintf(buf + len, "_TID=%d", task_pid_nr(current)) + 1;
>>> +       memcpy(buf + len, "_COMM=", 6);
>>> +       len += 6;
>>> +       get_task_comm(buf + len, current);
>>> +       while (buf[len] != '\0')
>>> +               len++;
>>
>>
>> len += strlen(buf); ?
>>
>> Is it obvious for some reason that this doesn't overflow buf?
>>
>
> KMSG_DICT_MAX_LEN sets architecture-intepentent max size.

And how many things are written and what asserts that it's big enough?

>
>> Why is task_pid_nr acceptable here?  Isn't this intended for use in
>> namespaces?
>>
>
> task_tgid_nr - process id (pid as seen in userspace),
> task_pid_nr - thread id

These are the ids as seen by the global namespace.  If the goal is to
create one of these nodes in some other namespace, then this is the
wrong thing to do.

--Andy
