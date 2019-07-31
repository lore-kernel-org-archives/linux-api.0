From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracefs: Restrict tracefs when the kernel is locked
 down
Date: Tue, 30 Jul 2019 21:48:03 -0400
Message-ID: <20190730214803.6d06da65@oasis.local.home>
References: <20190724222354.7cbd6c6e@oasis.local.home>
        <20190730184734.202386-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190730184734.202386-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, 30 Jul 2019 11:47:34 -0700
Matthew Garrett <matthewgarrett@google.com> wrote:

> Tracefs may release more information about the kernel than desirable, so
> restrict it when the kernel is locked down in confidentiality mode by
> preventing open().
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
