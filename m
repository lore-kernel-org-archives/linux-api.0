From: GeHao Kang <kanghao0928@gmail.com>
Subject: Context switch latency in tickless isolated CPU
Date: Wed, 17 Aug 2016 14:26:10 +0800
Message-ID: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: fweisbec@gmail.com, cmetcalf@mellanox.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, paulmck@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

Hi Frederic and Chris,

When the lmbench runs on the tickless isolated CPU, the context switch
latency on
this CPU is higher than the one on other CPU.  The test  platform is
Linux 4.4.12 with NO_HZ_FULL on I.MX6Q sabresd. The following is the
lmbench results about context switch:

lmbench runs on nonspecific CPU:
Context switching - times in microseconds - smaller is better
-------------------------------------------------------------------------
Host                 OS  2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
                         ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
--------- ------------- ------ ------ ------ ------ ------ ------- -------
imx6qsabr Linux 4.4.12-   12.6   12.8   16.1   26.6   42.1    36.5    70.0

lmbench runs on the isolated CPU:
Context switching - times in microseconds - smaller is better
-------------------------------------------------------------------------
Host                 OS  2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
                         ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
--------- ------------- ------ ------ ------ ------ ------ ------- -------
imx6qsabr Linux 4.4.12-   17.7   21.9   27.6   42.0   40.3    44.0    77.1

>From the results, only the test case with 8p/64K on the isolated CPU
has lower latency.

To investigate the cause, I use the kernel event tracer to find out
the events, user_enter and user_exit, of context_tracking would happen
on tickless isolated CPU. These two events means that this CPU enters
and exits the RCU extended quiescent state. Besides, the execution
time of these two events are 3us and 2us,
which are measured by ktime. Is this the reason why the context switch
has higher
latency on the tickless isolated CPU?

Thanks,

Regards,
- Kang
