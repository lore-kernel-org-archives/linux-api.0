From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Wed, 25 Sep 2019 15:51:34 +0200
Message-ID: <87h850scux.fsf@mid.deneb.enyo.de>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
        <87pnjr9rth.fsf@mid.deneb.enyo.de>
        <20190923142325.jowzbnwjw7g7si7j@wittgenstein>
        <90dd38d5-34b3-b72f-8e5a-b51f944f22fb@gmail.com>
        <20190924195701.7pw2olbviieqsg5q@wittgenstein>
        <b76adb4c-826b-6493-ba75-a9863066d3b1@gmail.com>
        <20190924215316.gxev2anuqffegocw@wittgenstein>
        <331cc245-3f70-dd43-31f9-8c1680ca6b20@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <331cc245-3f70-dd43-31f9-8c1680ca6b20@gmail.com> (Michael
        Kerrisk's message of "Wed, 25 Sep 2019 15:46:26 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Michael Kerrisk:

>        If these conditions don't hold true, then the child process should
>        instead be created using clone(2) with the CLONE_PID flag.

I think this should be CLONE_PIDFD.
