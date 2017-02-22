From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [GIT PULL] namespaces related fixes for v4.11-rc1
Date: Thu, 23 Feb 2017 08:15:46 +1100
Message-ID: <84361910-ba16-79ff-09cd-c76b3f66cc85@suse.de>
References: <8760k29cku.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <8760k29cku.fsf@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> The only known user of this prctl systemd
> forks all children after the prctl.  So no userspace regressions will
> occur.

Note that runC and containerd (and thus Docker) as well as cri-o use the 
prctl as well -- to be able to collect exit codes from a non-child 
process (namely to collect the exit code from PID 1 in the container).

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
