From: Stas Sergeev <stsp@list.ru>
Subject: [PATCH 0/2] sigaltstack: remove EPERM check
Date: Sat, 9 Jan 2016 04:00:00 +0300
Message-ID: <56905B90.6060505@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux kernel <linux-kernel@vger.kernel.org>
Cc: linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

The following patches add the self-test for
sigaltstack(SS_DISABLE) inside the signal handler,
and remove the EPERM check in a sigaltstack()
syscall.
This is needed to make sigaltstack() compatible with
swapcontext(): before using swapcontext() inside
the sighandler, the sigaltstack should be disabled, or
the stack will be corrupted by the subsequent signals.
