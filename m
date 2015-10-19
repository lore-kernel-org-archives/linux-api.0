From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC v3 8/9] kmsg: add predefined _PID, _TID, _COMM keywords to
 kmsg* log dict
Date: Mon, 19 Oct 2015 10:45:54 -0700
Message-ID: <CALCETrW2CgnS5pwS278ipLOSQi95UOT-osoSpshGwFmBf7TgRQ@mail.gmail.com>
References: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com> <1445259503-18158-9-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1445259503-18158-9-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 19, 2015 at 5:58 AM, Paul Osmialowski
<p.osmialowsk@samsung.com> wrote:
> From: Marcin Niesluchowski <m.niesluchow@samsung.com>
>
> kmsg* devices write operation wrote no dict along with message
> Due to usage of kmsg devices in userspace dict has been added
> identifying pid, tid and comm of writing process.

Does this affect even the normal /dev/kmsg?

> -static int kmsg_sys_write(int minor, int level, const char *fmt, ...)
> +static size_t set_kmsg_dict(char *buf)
> +{
> +       size_t len;
> +
> +       len = sprintf(buf, "_PID=%d", task_tgid_nr(current)) + 1;
> +       len += sprintf(buf + len, "_TID=%d", task_pid_nr(current)) + 1;
> +       memcpy(buf + len, "_COMM=", 6);
> +       len += 6;
> +       get_task_comm(buf + len, current);
> +       while (buf[len] != '\0')
> +               len++;

len += strlen(buf); ?

Is it obvious for some reason that this doesn't overflow buf?

Why is task_pid_nr acceptable here?  Isn't this intended for use in namespaces?

--Andy
