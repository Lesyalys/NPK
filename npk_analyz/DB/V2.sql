CREATE TABLE "teachers" (
  "id" SERIAL PRIMARY KEY,
  "full_name" "VARCHAR(100)" NOT NULL,
  "created_at" TIMESTAMP DEFAULT (NOW()),
  "updated_at" TIMESTAMP DEFAULT (NOW())
);

CREATE TABLE "students" (
  "id" SERIAL PRIMARY KEY,
  "full_name" "VARCHAR(100)" NOT NULL,
  "record_book_number" "VARCHAR(20)" UNIQUE NOT NULL,
  "group_name" "VARCHAR(20)",
  "teacher_id" INTEGER,
  "created_at" TIMESTAMP DEFAULT (NOW()),
  "updated_at" TIMESTAMP DEFAULT (NOW())
);

CREATE TABLE "exams" (
  "id" SERIAL PRIMARY KEY,
  "data" JSONB NOT NULL,
  "is_visible" BOOLEAN DEFAULT false,
  "creator_id" INTEGER,
  "created_at" TIMESTAMP DEFAULT (NOW()),
  "updated_at" TIMESTAMP DEFAULT (NOW())
);

CREATE TABLE "exam_answers" (
  "id" SERIAL PRIMARY KEY,
  "student_id" INTEGER,
  "exam_id" INTEGER,
  "answers" JSONB,
  "time_to_decide" timestamp,
  "created_at" TIMESTAMP DEFAULT (NOW())
);

CREATE TABLE "student_login_history" (
  "id" SERIAL PRIMARY KEY,
  "student_id" INTEGER,
  "login_time" TIMESTAMP DEFAULT (NOW()),
  "ip_address" "VARCHAR(45)",
  "user_agent" TEXT,
  "success" BOOLEAN
);

CREATE INDEX "idx_students_teacher" ON "students" ("teacher_id");

CREATE INDEX "idx_students_record_book" ON "students" ("record_book_number");

CREATE INDEX "idx_exams_creator" ON "exams" ("creator_id");

CREATE INDEX "idx_exams_visibility" ON "exams" ("is_visible");

CREATE INDEX "idx_answers_student" ON "exam_answers" ("student_id");

CREATE INDEX "idx_answers_exam" ON "exam_answers" ("exam_id");

CREATE UNIQUE INDEX "idx_answers_student_exam" ON "exam_answers" ("student_id", "exam_id");

COMMENT ON COLUMN "students"."record_book_number" IS 'Номер зачетки';

COMMENT ON COLUMN "students"."teacher_id" IS 'id преподавателя | Учитель id';

COMMENT ON COLUMN "exams"."data" IS 'данные экзамена';

COMMENT ON COLUMN "exams"."is_visible" IS 'видимость';

COMMENT ON COLUMN "exams"."creator_id" IS 'создатель | Учитель id';

COMMENT ON COLUMN "exam_answers"."student_id" IS 'id Студент | Студент id';

COMMENT ON COLUMN "exam_answers"."exam_id" IS 'id Экзамен | Экзамен id';

COMMENT ON COLUMN "exam_answers"."answers" IS 'Ответы студента';

ALTER TABLE "exams" ADD FOREIGN KEY ("creator_id") REFERENCES "teachers" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "exam_answers" ADD FOREIGN KEY ("exam_id") REFERENCES "exams" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "students" ADD FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "exam_answers" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "student_login_history" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("id") DEFERRABLE INITIALLY IMMEDIATE;
