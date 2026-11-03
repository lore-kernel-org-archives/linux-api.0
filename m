Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735933;
	b=r+R7S38SvUb8nwq1i6sYWWR1oFViV9rPFZg22XMzh3uXmW3Ch0TBi0D5Aijn8Vi2uCol
	 2vsD23xtOBB9/c1tIxj5nFYPr4Lguez3Uap9XUKcntj8xLuYRd9BRc6iQKjTEYKu/h280
	 pPNWlcvFQO7GiibtfKifUhTuLWJBlUJhdNYvdGAGJ/RXPZGDmtOAejBIO2MkVlFw14M5W
	 +J9kHsNaZLod1kmhNJfnUMuJdu+PkW7nPPt9X53j0HMNDRQdwdhCaTJDzCQd5HtD3npAG
	 +6/J7w188yWc1vD9squd4R82bwmVY3+TzvR4rq41OpwYPAnT2T4GY97QFhUUqep4XWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735933;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Content-Type;
	bh=msC8AEF28+LoD4wR4QMW7ybuarkuRynrg91O2ZPZPW4=;
	b=xLvgxN+HRA6hFExPisu/aYuN7bHjpgZDjKrMcLo6EF7t8TcP3RD2cmE8RWT9+8BiK6d/
	 A7zhf4SbcH2NiPpyLDn1UOCIPp+TJCXGD7kiul9v8XdiehLPuEEy9GrTSJjtcUli7+RYB
	 tak6P+SfscudbfA8A28KUNxEQWXd+e2eqWZecoAq6ZW5XMeB+8FvH+y2rhMkwRdKRKoIe
	 UNBwxLQAbP59LDgSHBSwzuCIHUvYgaG8d5Jm7FmUlqIyx0OdGhq03ofIYCDfOtGC/PUwv
	 xTibVRvuqdObMXwp0QyvsfJEG8Om/Ytzp07Z3SvqUwL4Rdrz6+ohrfBlk9YhzyXS8iA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OUWKSaqv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F890606A324
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 19:58:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F890606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OUWKSaqv
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5bcb4f23ddeso4324169e87.3
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 11:58:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793735931; cv=none;
        d=google.com; s=arc-20260327;
        b=SeUr8dHb+Fjqhhwx5sm+AnyKEMH9M+3963PWlcowdybw2oOVUiajEdViZzACrOymVx
         bPazp+mkg9rv4LBWnaSjZLVyfXQ0j2GX2Zeu3NhALVMPZvReECI/J57ZJy/z6L0sxeVP
         +JHYS+nCFaZvD4wYlnmsMq9D10LGJA+eeX/gEUqVQCkgRg6AFn0/+UKU816LyIq6WzX+
         tu5Lo0pJQQhnwknSpDhTl5PPpFEF6D2hcdb7xJ1h1lSCh3gBVrsdxq1F9/wzFkqeqpvU
         225MxjWs2m1U/L/nP7h6+dN15d5/GHBwyR+uGbwDAGbRMB8JZnd6cR9dazeI3CiwP1+x
         q7Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=msC8AEF28+LoD4wR4QMW7ybuarkuRynrg91O2ZPZPW4=;
        fh=BR4kpKV8ytqLuqXGf93PdoVV7PFD+qZQTuS3SXrYiCE=;
        b=esxdhd1dH9d8ym4OFvzYJJFi6kpyaBmeV8eU3C7Stzg2k9ssbpBAKBpKvhaNhqBsLi
         ecenFOSg1xYqIRudy330/RBAeely9OvUCVBH99/XZ7YDfKbiwwqVxeyFcGHrjFHFsxL+
         /J5kEfMfbx+dcj15wpi3z5nUDKDiPz81Vh5hivNXlRoGQOLXS0xuC6fGWlXmmVIQXqwi
         KnoTY6V+die1e+5WS2jH+tKIZOjTs0T2aAF254yonJlHxG5OeGaa4IhImAbd8NqF7e4f
         tJq650BJVgYbApEKV7oT7t9uWGTnLzni2nIh7j35mOYo4z11wGOeAq2X49pedaP8UXK7
         C26A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793735931; x=1794340731; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=msC8AEF28+LoD4wR4QMW7ybuarkuRynrg91O2ZPZPW4=;
        b=OUWKSaqvQkmcspifGwE+EUFLnJNYnk1pd+X7y2Y3MaFNVGje4/4Zjo81naXmQymB0P
         erAk3MBi8RbpVw7hiycXO4gs4tyh0syx3KYCD7ME14rViIO7Ta3Hni5mYE2SGGfxxGBl
         fuxrht0kRuBtkV2SNJN8jNcHRk/Cm2Wd+f7P0R1b9a029msFihbfseZ5OZersC6LP0kB
         qkquA08gvdbVxN5omTGAqCDYYOvyJx1bVkxMDlotZipaQwCTzf1m4UdxQiyATCquPLFX
         dpB0MGGFQHAIcHbrVr1RjNrVbd7m6eKO7IMJz9qi0Ub7lFvBHrzdnpXjes1Uby4MQiTd
         N7Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735931; x=1794340731;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=msC8AEF28+LoD4wR4QMW7ybuarkuRynrg91O2ZPZPW4=;
        b=mpwlLvQAnvH/rQ+5qLCGx2a95uLzbqCULgjgR0Q65fweWyfYwa/39RBIlMr8a7l7Ib
         /SCz4OTG2rf7Y6MnK6G86dqzDDFfKbSiJo0DV/zRD+FlIHYCK7BFPLzRkz41RCeqP9oE
         PZcT+z888+wNzoBFGEI6z7/SewCwJxdG7Mr+kjErqlmQ63doDSkv+o8MJCpvjQMlGWe8
         WcbWzM8VI26ayyejQM9cg7CHbPKOabwYOVFYAl4NYBtDrBs5PUtTSuB0pEZXk8hyldbE
         wcXAHutjmHH3cii0RbIf65Dwa5v0MoC/IJLJGwNRZouRWCnTezJzHTLJDFKnh9JN2IcK
         BcoA==
X-Forwarded-Encrypted: i=1; AKwUvBzAVPuORgiIO9mRwTtk2JjbwkwxvxCRkdl1+a2WwzCBfm4iPvyLjHk2uXFyP2XgklsHSj2kpHWFP/w=@vger.kernel.org
X-Gm-Message-State: APuU4Z9dccwhCaIhkcIPAzbDkQjcep4f6u+JzZ4DBaq0uKkLaIw8A9fy
	64QzTR1ZcO/RwOqhp6l8SGg+1jUfXcik0Erlf9nXOwr4qrQMPYtcpVY0zp+E3L1fzbUKdJKCo5K
	RAI4Lm2a+cleR1zhcjlLNW02nIBd88UBS1qDQekEi
X-Gm-Gg: AYBFou3qmmt0OcrBgPbhoOwxaZhuXyfHF6QU2IqeA7/0vRTHc1lpFGWgezrA+pEoCBu
	TBoFqQWzQIRjX7jGrz7iACnQHXD1Ce5GAX+6sj2vCSbinWs58SeHseYtFth0JlEnAm0l1ROaivA
	HsK5avIeWfETGNeHlw/FgC7IRkXD0Js8LgjSvVBNC59DkATo6P7hzoiQ2R2hNG38bYe6/tGQ87S
	1AKHWXbxT2c26nT+J7knodkmA9EmKc81Wse858bdZk0sEZx6kVlrXKU2TNiOzBNFjkmI+RCnvsN
	mpJn0jB845ee56AjMxLevh87oSRw2LTw0rStm+VnW4fJ08KgoL4Hmi1bp9fptPIBp/a+/LnZEv0
	xHlDEdjunNxDpd7shLbP5wvXD4PFt+V0laQ==
X-Received: by 2002:a05:6512:3044:b0:5bc:cb94:830b with SMTP id
 2adb3069b0e04-5bfd957fbc9mr4631201e87.55.1793735930576; Tue, 03 Nov 2026
 11:58:50 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 3 Nov 2026 11:58:38 -0800
X-Gm-Features: AclHuK_bN6YrhtswWu642OC1b8BtqaJiPZLecfCpjtFSxigsPxo-YRM7r02qtCE
Message-ID: <CALCETrWDJKr=LMzfPjwwRRuKapFKQ_OaYF6qYz-9Cs91xAXUgA@mail.gmail.com>
Subject: Accidental mountns/tmpfs API break from 2016?
To: "Eric W. Biederman" <ebiederm@xmission.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi-

I (well, an LLM following my rather explicit instructions) just wrote
a little tool to make a tmpfs as an unprivileged user: it unshares
userns and mountns, makes a tmpfs, fchdirs to it, and prints
/proc/PID/cwd to stdout.  Full source below.

I was a bit surprised that trying to create anything in the tmpfs did
not work without a uid_map and gid_map.  It looks like it came from:

commit 036d523641c66bef713042894a17f4335f199e49
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Fri Jul 1 12:52:06 2016 -0500

    vfs: Don't create inodes with a uid or gid unknown to the vfs

    It is expected that filesystems can not represent uids and gids from
    outside of their user namespace.  Keep things simple by not even
    trying to create filesystem nodes with non-sense uids and gids.

    Acked-by: Seth Forshee <seth.forshee@canonical.com>
    Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>


Now my tool won't actually run on a pre-2016 kernel due to use of
fsopen, and I'm not about to say that a decade-old commit broke my ABI
and needs to be reverted.  But I am rather curious whether this rule
actually makes sense.  I'm not creating an idmapped mount, and I'm
using tmpfs, which could not care less about the mapping as far as I
know.

Would it make sense to only enforce this for filesystems that care?

--Andy


#include <cerrno>
#include <cstdio>
#include <fcntl.h>
#include <linux/mount.h>
#include <sched.h>
#include <string>
#include <string_view>
#include <sys/syscall.h>
#include <system_error>
#include <unistd.h>

namespace {
void Check(long result, const char *operation) {
    if (result < 0)
        throw std::system_error(errno, std::generic_category(), operation);
}

struct OwnedFd {
    int fd;

    ~OwnedFd() { close(fd); }
};

void WriteAll(int fd, std::string_view bytes) {
    while (!bytes.empty()) {
        auto n = write(fd, bytes.data(), bytes.size());
        if (n < 0 && errno == EINTR)
            continue;
        Check(n, "write");
        if (n == 0)
            throw std::system_error(EIO, std::generic_category(),
"zero-length write");
        bytes.remove_prefix(n);
    }
}

void WriteFile(const char *path, std::string_view bytes) {
    OwnedFd file{open(path, O_WRONLY | O_CLOEXEC)};
    Check(file.fd, path);
    WriteAll(file.fd, bytes);
}
}

int cmd_temp_shm(int argc, char **) {
    if (argc != 1) {
        fprintf(stderr, "Usage: lktool temp_shm\n");
        return 1;
    }

    try {
        auto uid = getuid();
        auto gid = getgid();
        Check(unshare(CLONE_NEWUSER | CLONE_NEWNS), "unshare user and
mount namespaces");

        /*
         * The outside UID and GID need to be mapped in order for the
outside tasks
         * to create dentries.  This comes from commit 036d523641c6
("vfs: Don't create
         * inodes with a uid or gid unknown to the vfs"), which I
think may have been
         * a mistake.
         */
        WriteFile("/proc/self/setgroups", "deny\n");
        WriteFile("/proc/self/uid_map", "0 " + std::to_string(uid) + " 1\n");
        WriteFile("/proc/self/gid_map", "0 " + std::to_string(gid) + " 1\n");

        OwnedFd context{static_cast<int>(syscall(SYS_fsopen, "tmpfs",
FSOPEN_CLOEXEC))};
        Check(context.fd, "fsopen tmpfs");
        Check(syscall(SYS_fsconfig, context.fd, FSCONFIG_CMD_CREATE,
nullptr, nullptr, 0),
              "fsconfig create tmpfs");

        OwnedFd mount{static_cast<int>(syscall(SYS_fsmount,
context.fd, FSMOUNT_CLOEXEC, 0))};
        Check(mount.fd, "fsmount tmpfs");
        Check(fchdir(mount.fd), "fchdir tmpfs");

        // The detached mount is kept alive by cwd and the mount descriptor.
        // No mount is attached to the inherited filesystem hierarchy.
        std::string path = "/proc/" + std::to_string(getpid()) + "/cwd";
        path.push_back('\0');
        WriteAll(STDOUT_FILENO, path);
        for (;;)
            pause();
    } catch (const std::system_error &e) {
        fprintf(stderr, "lktool temp_shm: %s\n", e.what());
        return 1;
    }
}
