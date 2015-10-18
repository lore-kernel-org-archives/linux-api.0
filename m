From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Mon, 19 Oct 2015 00:06:38 +0200
Message-ID: <562417EE.4070602@nod.at>
References: <5622700C.9090107@miglix.eu>
 <CAFLxGvzJONWTbpD8GFfDWDQiPxONrFaRAuXonXXUWaR1pcTUgw@mail.gmail.com>
 <5623FD86.2030609@miglix.eu> <5623FF36.8080800@nod.at>
 <562403E7.6070300@miglix.eu> <56240599.3050903@nod.at>
 <562413FD.2020401@miglix.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <562413FD.2020401@miglix.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Tobias Markus <tobias@miglix.eu>
Cc: LKML <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andrew Morton <akpm@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Christoph Lameter <cl@linux.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, LSM <linux-security-module@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am 18.10.2015 um 23:49 schrieb Tobias Markus:
> But before we continue arguing endlessly, I just got an idea: What about
> adding a sysctl to enable/disable enforcement of the hypothetical
> CAP_SYS_USER_NS, just like with /proc/sys/kernel/kptr_restrict and
> CAP_SYSLOG? Would also prevent any potential userspace breakage.

My argument stands, hiding user namespaces behind whatever
switch and rendering it into a second class citizen does not improve its security.

Especially ad-hoc solutions are not expedient. Reducing the attack surface must not
lead to gazillions of new capabilities, sysctl switches, etc...
user namespaces are neither the first nor the last "critical" kernel feature.

I'm sure RHEL will ship a SELinux boolean to disable user namespaces as they do
for many other OS features. This is fine and exactly why we have LSM.

Thanks,
//richard
