From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH V4] pidns: introduce syscall translate_pid
Date: Tue, 3 Apr 2018 14:38:38 -0700
Message-ID: <20180403143838.614ecc083835d07d409a699c@linux-foundation.org>
References: <1522706249-11578-1-git-send-email-nagarathnam.muthusamy@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522706249-11578-1-git-send-email-nagarathnam.muthusamy@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: nagarathnam.muthusamy@oracle.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, khlebnikov@yandex-team.ru, serge.hallyn@ubuntu.com, oleg@redhat.com, luto@amacapital.net, jannh@google.com, prakash.sangappa@oracle.com
List-Id: linux-api@vger.kernel.org

On Mon,  2 Apr 2018 15:57:29 -0600 nagarathnam.muthusamy@oracle.com wrote:

> pid_t translate_pid(pid_t pid, int source, int target);
> 
> This syscall converts pid from source pid-ns into pid in target pid-ns.
> If pid is unreachable from target pid-ns it returns zero.
> 
> Pid-namespaces are referred file descriptors opened to proc files
> /proc/[pid]/ns/pid or /proc/[pid]/ns/pid_for_children. Negative argument
> refers to current pid namespace, same as file /proc/self/ns/pid.
> 
> Kernel expose virtual pids in /proc/[pid]/status:NSpid, but backward
> translation requires scanning all tasks. Also pids could be translated
> by sending them through unix socket between namespaces, this method is
> slow and insecure because other side is exposed inside pid namespace.
> 
> Examples:
> translate_pid(pid, ns, -1)      - get pid in our pid namespace
> translate_pid(pid, -1, ns)      - get pid in other pid namespace
> translate_pid(1, ns, -1)        - get pid of init task for namespace
> translate_pid(pid, -1, ns) > 0  - is pid is reachable from ns?
> translate_pid(1, ns1, ns2) > 0  - is ns1 inside ns2?
> translate_pid(1, ns1, ns2) == 0 - is ns1 outside ns2?
> translate_pid(1, ns1, ns2) == 1 - is ns1 equal ns2?
> 
> Error codes:
> EBADF    - file descriptor is closed
> EINVAL   - file descriptor isn't pid-namespace
> ESRCH    - task not found in @source namespace

Presumably a manpage is planned?

This changelog doesn't explain what the value is to our users.  I
assume it is a performance optimization because "backward translation
requires scanning all tasks"?  If so, please show us real-world
examples of the performance benefit from this patch, and please go to
great lengths to explain to us why this optimisation is needed by our
users.
