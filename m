From: Shawn Landden <slandden@gmail.com>
Subject: Re: [RFC v4] It is common for services to be stateless around their
 main event loop. If a process sets PR_SET_IDLE to PR_IDLE_MODE_KILLME then it
 signals to the kernel that epoll_wait() and friends may not complete, and the
 kernel may send SIGKILL if resources get tight.
Date: Mon, 20 Nov 2017 21:26:45 -0800
Message-ID: <CA+49okr0PC5sOuLQfuBt3J6KtWANa4eYoDpqOvp7rbQ9JDWQ5Q@mail.gmail.com>
References: <20171121044947.18479-1-slandden@gmail.com> <20171121051639.1228-1-slandden@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20171121051639.1228-1-slandden@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Shawn Landden <slandden@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, willy@infradead.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 20, 2017 at 9:16 PM, Shawn Landden <slandden@gmail.com> wrote:
> See my systemd patch: https://github.com/shawnl/systemd/tree/prctl
>
> Android uses this memory model for all programs, and having it in the
> kernel will enable integration with the page cache (not in this
> series).
What about having a dedicated way to kill these type of processes,
instead of overloading the OOM killer? This was suggested by
Colin Walters <walters@verbum.org>
